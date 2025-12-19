CREATE TABLE outComingItems (
    ociId INT AUTO_INCREMENT PRIMARY KEY,

    itemsId INT NOT NULL,
    businessId INT NOT NULL,
    userId INT NOT NULL,

    quantity INT NOT NULL,
    unitPrice DECIMAL(15,2) DEFAULT 0,

    totalSale DECIMAL(15,2) GENERATED ALWAYS AS (quantity * unitPrice) STORED,

    outComingDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- relasi 
    CONSTRAINT fk_oci_items
        FOREIGN KEY (itemsId)
        REFERENCES items(itemsId)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_oci_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_oci_user
        FOREIGN KEY (userId)
        REFERENCES users(userId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DELIMITER $$ 
-- Trigger: trg_outComingItems_after_update
CREATE TRIGGER trg_outComingItems_after_update
AFTER UPDATE ON outComingItems
FOR EACH ROW
BEGIN
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        NEW.businessId,
        'UPDATE',
        'outComingItems',
        NEW.ociId,
        JSON_OBJECT(
            'itemsId', JSON_OBJECT('old', OLD.itemsId, 'new', NEW.itemsId),
            'userId', JSON_OBJECT('old', OLD.userId, 'new', NEW.userId),
            'quantity', JSON_OBJECT('old', OLD.quantity, 'new', NEW.quantity),
            'unitPrice', JSON_OBJECT('old', OLD.unitPrice, 'new', NEW.unitPrice),
            'totalSale', JSON_OBJECT('old', OLD.totalSale, 'new', NEW.totalSale),
            'outComingDate', JSON_OBJECT('old', OLD.outComingDate, 'new', NEW.outComingDate)
        )
    );
END $$

-- Trigger: trg_outComingItems_before_delete
CREATE TRIGGER trg_outComingItems_before_delete
BEFORE DELETE ON outComingItems
FOR EACH ROW
BEGIN
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        OLD.businessId,
        'DELETE',
        'outComingItems',
        OLD.ociId,
        JSON_OBJECT(
            'itemsId', OLD.itemsId,
            'userId', OLD.userId,
            'quantity', OLD.quantity,
            'unitPrice', OLD.unitPrice,
            'totalSale', OLD.totalSale,
            'outComingDate', OLD.outComingDate
        )
    );
END $$

-- Trigger: trg_outComingItems_after_insert
CREATE TRIGGER trg_outComingItems_after_insert
AFTER INSERT ON outComingItems
FOR EACH ROW
BEGIN
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        NEW.businessId,
        'INSERT',
        'outComingItems',
        NEW.ociId,
        JSON_OBJECT(
            'itemsId', NEW.itemsId,
            'userId', NEW.userId,
            'quantity', NEW.quantity,
            'unitPrice', NEW.unitPrice,
            'totalSale', NEW.totalSale,
            'outComingDate', NEW.outComingDate
        )
    );
END $$

CREATE PROCEDURE GetBestSellingItems(
    IN p_businessId INT
)
BEGIN
    SELECT 
        RANK() OVER (ORDER BY SUM(oci.quantity) DESC) AS ranking,
        i.itemName AS nama_barang,
        i.category AS kategori,
        SUM(oci.quantity) AS total_terjual,
        COUNT(oci.ociId) AS jumlah_transaksi,
        FORMAT(AVG(oci.unitPrice), 0) AS harga_rata_rata,
        FormatRupiah(SUM(oci.totalSale)) AS total_penjualan
    FROM outComingItems oci
    JOIN items i ON oci.itemsId = i.itemsId
    WHERE oci.businessId = p_businessId
    GROUP BY i.itemsId, i.itemName, i.category
    ORDER BY total_terjual DESC;
END $$

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
    
END $$

-- Trigger Update Stok Saat Barang Keluar
CREATE TRIGGER UpdateStockAfterOutgoing
AFTER INSERT ON outComingItems
FOR EACH ROW
BEGIN
    -- Update stok di tabel items (dikurangi)
    UPDATE items 
    SET stockQuantity = stockQuantity - NEW.quantity
    WHERE itemsId = NEW.itemsId;
END $$

-- Trigger untuk mengkalkulasi profit harian dari penjualan
CREATE TRIGGER trg_after_outcomingitems_insert
AFTER INSERT ON outComingItems
FOR EACH ROW
BEGIN
    DECLARE v_summaryDate DATE;
    DECLARE v_totalSale DECIMAL(15,2);
    
    -- Ambil tanggal transaksi
    SET v_summaryDate = DATE(NEW.outComingDate);
    
    -- Gunakan nilai totalSale yang sudah di-generate
    SET v_totalSale = NEW.totalSale;
    
    -- Jika data harian sudah ada → UPDATE
    IF EXISTS (
        SELECT 1 
        FROM dailyProfitLoss 
        WHERE businessId = NEW.businessId 
          AND summaryDate = v_summaryDate
    ) THEN
    
        UPDATE dailyProfitLoss
        SET 
            dailyRevenue = dailyRevenue + v_totalSale,
            dailyGrossProfit = (dailyRevenue + v_totalSale) - dailyCOGS
        WHERE businessId = NEW.businessId
          AND summaryDate = v_summaryDate;
    
    -- Jika belum ada → INSERT
    ELSE
    
        INSERT INTO dailyProfitLoss (
            businessId,
            summaryDate,
            dailyRevenue,
            dailyCOGS,
            dailyGrossProfit
        ) VALUES (
            NEW.businessId,
            v_summaryDate,
            v_totalSale,
            0,
            v_totalSale  -- Gross Profit = Revenue - COGS (0)
        );
    
    END IF;
END $$

-- Trigger untuk rollback stok jika data outComingItems dihapus
CREATE TRIGGER RestoreStockAfterOutgoingDelete
AFTER DELETE ON outComingItems
FOR EACH ROW
BEGIN
    -- Kembalikan stok ke jumlah semula
    UPDATE items 
    SET stockQuantity = stockQuantity + OLD.quantity
    WHERE itemsId = OLD.itemsId;
END $$

-- Trigger untuk update profit harian jika data outComingItems dihapus
CREATE TRIGGER trg_after_outcomingitems_delete
AFTER DELETE ON outComingItems
FOR EACH ROW
BEGIN
    DECLARE v_summaryDate DATE;
    DECLARE v_totalSale DECIMAL(15,2);
    
    -- Ambil tanggal transaksi lama
    SET v_summaryDate = DATE(OLD.outComingDate);
    SET v_totalSale = OLD.totalSale;
    
    -- Update dailyProfitLoss dengan mengurangi revenue
    IF EXISTS (
        SELECT 1 
        FROM dailyProfitLoss 
        WHERE businessId = OLD.businessId 
          AND summaryDate = v_summaryDate
    ) THEN
    
        UPDATE dailyProfitLoss
        SET 
            dailyRevenue = dailyRevenue - v_totalSale,
            dailyGrossProfit = (dailyRevenue - v_totalSale) - dailyCOGS
        WHERE businessId = OLD.businessId
          AND summaryDate = v_summaryDate;
    
    END IF;
END $$

DELIMITER ;
