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

-- Hapus trigger yang redundan
DROP TRIGGER IF EXISTS UpdateStockAfterOutgoing;
DROP TRIGGER IF EXISTS trg_after_outcomingitems_insert;
DROP TRIGGER IF EXISTS RestoreStockAfterOutgoingDelete;
DROP TRIGGER IF EXISTS trg_after_outcomingitems_delete;

DELIMITER $$

-- Trigger UPDATE untuk logs
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

-- Trigger DELETE untuk logs
CREATE TRIGGER trg_outComingItems_before_delete
BEFORE DELETE ON outComingItems
FOR EACH ROW
BEGIN
    -- Log penghapusan
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
    
    -- Kembalikan stok
    UPDATE items 
    SET stockQuantity = stockQuantity + OLD.quantity
    WHERE itemsId = OLD.itemsId;
    
    -- Update dailyProfitLoss
    UPDATE dailyProfitLoss
    SET 
        dailyRevenue = dailyRevenue - OLD.totalSale,
        dailyGrossProfit = dailyRevenue - dailyCOGS
    WHERE businessId = OLD.businessId 
      AND summaryDate = DATE(OLD.outComingDate);
END $$

-- Trigger INSERT untuk logs
CREATE TRIGGER trg_outComingItems_after_insert
AFTER INSERT ON outComingItems
FOR EACH ROW
BEGIN
    -- Log insert
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
    
    -- Update dailyProfitLoss dengan cara yang benar
    INSERT INTO dailyProfitLoss (
        businessId,
        summaryDate,
        dailyRevenue,
        dailyCOGS,
        dailyGrossProfit
    ) VALUES (
        NEW.businessId,
        DATE(NEW.outComingDate),
        NEW.totalSale,
        0,
        NEW.totalSale
    )
    ON DUPLICATE KEY UPDATE
        dailyRevenue = dailyRevenue + NEW.totalSale,
        dailyGrossProfit = dailyRevenue + NEW.totalSale - dailyCOGS;
END $$

-- Procedure untuk mendapatkan barang terlaris
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

-- Procedure utama untuk insert barang keluar (MENGGANTI trigger lama)
CREATE PROCEDURE InsertOutComingItem(
    IN p_itemsId INT,
    IN p_businessId INT,
    IN p_userId INT,
    IN p_quantity INT,
    IN p_unitPrice DECIMAL(15,2)
)
BEGIN
    DECLARE v_currentStock INT;
    DECLARE v_purchasePrice DECIMAL(15,2);
    DECLARE v_totalSale DECIMAL(15,2);
    DECLARE v_newOciId INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Lock dan cek stok
    SELECT stockQuantity, purchasePrice
    INTO v_currentStock, v_purchasePrice
    FROM items
    WHERE itemsId = p_itemsId
      AND businessId = p_businessId
    FOR UPDATE;

    IF v_currentStock IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Item tidak ditemukan';
    END IF;

    IF v_currentStock < p_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stok tidak mencukupi';
    END IF;

    -- Hitung total sale
    SET v_totalSale = p_quantity * p_unitPrice;

    -- Insert ke outComingItems
    INSERT INTO outComingItems (
        itemsId,
        businessId,
        userId,
        quantity,
        unitPrice,
        totalSale,
        outComingDate
    ) VALUES (
        p_itemsId,
        p_businessId,
        p_userId,
        p_quantity,
        p_unitPrice,
        v_totalSale,
        NOW()
    );
    
    SET v_newOciId = LAST_INSERT_ID();

    -- Update stok
    UPDATE items 
    SET stockQuantity = stockQuantity - p_quantity
    WHERE itemsId = p_itemsId;

    -- Update dailyProfitLoss dalam satu transaksi
    INSERT INTO dailyProfitLoss (
        businessId,
        summaryDate,
        dailyRevenue,
        dailyCOGS,
        dailyGrossProfit
    ) VALUES (
        p_businessId,
        CURDATE(),
        v_totalSale,
        0,
        v_totalSale
    )
    ON DUPLICATE KEY UPDATE
        dailyRevenue = dailyRevenue + v_totalSale,
        dailyGrossProfit = dailyRevenue + v_totalSale - dailyCOGS;

    COMMIT;

    -- Return hasil
    SELECT
        'SUCCESS' AS status,
        'Barang keluar berhasil' AS message,
        v_newOciId AS outComing_id,
        v_currentStock AS stock_before,
        (v_currentStock - p_quantity) AS stock_after,
        FormatRupiah(v_purchasePrice) AS purchase_price,
        FormatRupiah(p_unitPrice) AS sale_price,
        FormatRupiah(v_totalSale) AS total_sale;

END$$

-- Trigger untuk UPDATE (jika data outComingItems diupdate)
CREATE TRIGGER trg_outComingItems_after_update_complete
AFTER UPDATE ON outComingItems
FOR EACH ROW
BEGIN
    DECLARE v_quantity_diff INT;
    DECLARE v_totalSale_diff DECIMAL(15,2);
    
    -- Jika ada perubahan quantity atau unitPrice
    IF OLD.quantity != NEW.quantity OR OLD.unitPrice != NEW.unitPrice THEN
        SET v_quantity_diff = NEW.quantity - OLD.quantity;
        SET v_totalSale_diff = NEW.totalSale - OLD.totalSale;
        
        -- Update stok berdasarkan selisih quantity
        UPDATE items 
        SET stockQuantity = stockQuantity - v_quantity_diff
        WHERE itemsId = NEW.itemsId;
        
        -- Update dailyProfitLoss
        IF v_totalSale_diff != 0 THEN
            UPDATE dailyProfitLoss
            SET 
                dailyRevenue = dailyRevenue + v_totalSale_diff,
                dailyGrossProfit = dailyRevenue - dailyCOGS
            WHERE businessId = NEW.businessId 
              AND summaryDate = DATE(NEW.outComingDate);
        END IF;
    END IF;
END $$

DELIMITER ;