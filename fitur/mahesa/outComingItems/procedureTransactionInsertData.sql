CREATE PROCEDURE InsertOutcomingItemSafe(
    IN p_itemsId INT,
    IN p_businessId INT,
    IN p_userId INT,
    IN p_quantity INT,
    IN p_unitPrice DECIMAL(15,2)
)
BEGIN
    DECLARE v_currentStock INT;
    DECLARE v_sellingPrice DECIMAL(15,2);
    DECLARE v_itemName VARCHAR(150);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- 1. Ambil data untuk validasi
    SELECT stockQuantity, sellingPrice, itemName 
    INTO v_currentStock, v_sellingPrice, v_itemName
    FROM items 
    WHERE itemsId = p_itemsId AND businessId = p_businessId;
    
    IF v_itemName IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Item tidak ditemukan';
    END IF;
    
    -- 2. Validasi stok
    IF v_currentStock < p_quantity THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = CONCAT(
            'Stok tidak mencukupi. Stok tersedia: ', 
            v_currentStock, 
            ', Permintaan: ', 
            p_quantity
        );
    END IF;
    
    -- 3. Warning jika harga terlalu rendah
    IF p_unitPrice < (v_sellingPrice * 0.5) THEN
        SET @warning = CONCAT(
            'WARNING: Harga jual (', FORMAT(p_unitPrice, 0), 
            ') lebih rendah 50% dari harga standar (', 
            FORMAT(v_sellingPrice, 0), ')'
        );
    END IF;
    
    -- 4. HANYA INSERT, biarkan trigger update stok
    INSERT INTO outComingItems (
        itemsId,
        businessId,
        userId,
        quantity,
        unitPrice
    ) VALUES (
        p_itemsId,
        p_businessId,
        p_userId,
        p_quantity,
        p_unitPrice
    );
    
    -- 5. UPDATE MOVING STATUS SAJA (stok sudah di-update trigger)
    -- Gunakan stok baru (setelah dikurangi)
    UPDATE items
    SET movingStatus = CASE
        WHEN (v_currentStock - p_quantity) > 100 THEN 'FAST'
        WHEN (v_currentStock - p_quantity) BETWEEN 20 AND 100 THEN 'SLOW'
        ELSE 'DEAD'
    END
    WHERE itemsId = p_itemsId;
    
    COMMIT;
    
    -- Return success
    SELECT 
        'SUCCESS' as status,
        CONCAT('Penjualan ', v_itemName, ' berhasil') as message,
        LAST_INSERT_ID() as outgoing_id,
        p_quantity as quantity_sold,
        FormatRupiah(p_unitPrice) as selling_price,
        FormatRupiah(p_quantity * p_unitPrice) as total_sale,
        v_currentStock as stock_before,
        (v_currentStock - p_quantity) as stock_after,
        IFNULL(@warning, 'OK') as warning_message;
    
END
