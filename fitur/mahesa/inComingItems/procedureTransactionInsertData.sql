CREATE PROCEDURE InsertIncomingItem(
    IN p_itemsId INT,
    IN p_businessId INT,
    IN p_userId INT,
    IN p_quantity INT,
    IN p_unitPrice DECIMAL(15,2)
)
BEGIN
    DECLARE v_currentPrice DECIMAL(15,2);
    DECLARE v_newAvgPrice DECIMAL(15,2);
    DECLARE v_currentStock INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- 1. Ambil data current untuk kalkulasi rata-rata
    SELECT purchasePrice, stockQuantity 
    INTO v_currentPrice, v_currentStock
    FROM items 
    WHERE itemsId = p_itemsId AND businessId = p_businessId;
    
    IF v_currentPrice IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Item tidak ditemukan';
    END IF;
    
    -- 2. Hitung harga rata-rata baru (weighted average)
    SET v_newAvgPrice = CASE 
        WHEN v_currentStock + p_quantity > 0 THEN
            ((v_currentPrice * v_currentStock) + (p_unitPrice * p_quantity)) 
            / (v_currentStock + p_quantity)
        ELSE p_unitPrice
    END;
    
    -- 3. Insert ke inComingItems (trigger akan update stok)
    INSERT INTO inComingItems (
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
    
    -- 4. Update harga beli rata-rata (INI SATU-SATUNYA UPDATE di prosedur)
    UPDATE items 
    SET purchasePrice = ROUND(v_newAvgPrice, 2)
    WHERE itemsId = p_itemsId;
    
    COMMIT;
    
    SELECT 
        'SUCCESS' as status,
        'Barang masuk berhasil dengan update harga rata-rata' as message,
        LAST_INSERT_ID() as incoming_id,
        FormatRupiah(v_currentPrice) as old_price,
        FormatRupiah(v_newAvgPrice) as new_avg_price,
        FormatRupiah(p_unitPrice) as input_price;
    
END
