CREATE TABLE inComingItems (
    iciId INT AUTO_INCREMENT PRIMARY KEY,

    itemsId INT NOT NULL,
    businessId INT NOT NULL,
    userId INT NOT NULL,

    quantity INT NOT NULL,
    unitPrice DECIMAL(15,2) DEFAULT 0,

    totalPurchase DECIMAL(15,2) GENERATED ALWAYS AS (quantity * unitPrice) STORED,

    inComingDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- relasi
    CONSTRAINT fk_ici_items
        FOREIGN KEY (itemsId)
        REFERENCES items(itemsId)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_ici_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_ici_user
        FOREIGN KEY (userId)
        REFERENCES users(userId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
-- Hapus trigger yang redundan
DROP TRIGGER IF EXISTS UpdateStockAfterIncoming;
DROP TRIGGER IF EXISTS trg_after_incomingitems_insert;
DROP TRIGGER IF EXISTS RestoreStockAfterIncomingDelete;
DROP TRIGGER IF EXISTS trg_after_incomingitems_delete;

DELIMITER $$

-- Trigger UPDATE untuk logs
CREATE TRIGGER trg_inComingItems_after_update
AFTER UPDATE ON inComingItems
FOR EACH ROW
BEGIN
    DECLARE v_quantity_diff INT;
    DECLARE v_totalPurchase_diff DECIMAL(15,2);
    DECLARE v_old_purchase_price DECIMAL(15,2);
    DECLARE v_new_purchase_price DECIMAL(15,2);
    DECLARE v_current_stock INT;
    
    -- Log update
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        NEW.businessId,
        'UPDATE',
        'inComingItems',
        NEW.iciId,
        JSON_OBJECT(
            'itemsId', JSON_OBJECT('old', OLD.itemsId, 'new', NEW.itemsId),
            'userId', JSON_OBJECT('old', OLD.userId, 'new', NEW.userId),
            'quantity', JSON_OBJECT('old', OLD.quantity, 'new', NEW.quantity),
            'unitPrice', JSON_OBJECT('old', OLD.unitPrice, 'new', NEW.unitPrice),
            'totalPurchase', JSON_OBJECT('old', OLD.totalPurchase, 'new', NEW.totalPurchase),
            'inComingDate', JSON_OBJECT('old', OLD.inComingDate, 'new', NEW.inComingDate)
        )
    );
    
    -- Update stok dan COGS jika ada perubahan quantity atau unitPrice
    IF OLD.quantity != NEW.quantity OR OLD.unitPrice != NEW.unitPrice THEN
        SET v_quantity_diff = NEW.quantity - OLD.quantity;
        SET v_totalPurchase_diff = NEW.totalPurchase - OLD.totalPurchase;
        
        -- Update stok
        UPDATE items 
        SET stockQuantity = stockQuantity + v_quantity_diff
        WHERE itemsId = NEW.itemsId;
        
        -- Update dailyProfitLoss (COGS)
        IF v_totalPurchase_diff != 0 THEN
            UPDATE dailyProfitLoss
            SET 
                dailyCOGS = dailyCOGS + v_totalPurchase_diff,
                dailyGrossProfit = dailyRevenue - dailyCOGS
            WHERE businessId = NEW.businessId 
              AND summaryDate = DATE(NEW.inComingDate);
        END IF;
    END IF;
END$$

-- Trigger DELETE untuk logs dan update stok
CREATE TRIGGER trg_inComingItems_before_delete
BEFORE DELETE ON inComingItems
FOR EACH ROW
BEGIN
    DECLARE v_current_purchase_price DECIMAL(15,2);
    DECLARE v_current_stock INT;
    DECLARE v_new_avg_price DECIMAL(15,2);
    
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
        'inComingItems',
        OLD.iciId,
        JSON_OBJECT(
            'itemsId', OLD.itemsId,
            'userId', OLD.userId,
            'quantity', OLD.quantity,
            'unitPrice', OLD.unitPrice,
            'totalPurchase', OLD.totalPurchase,
            'inComingDate', OLD.inComingDate
        )
    );
    
    -- Ambil data current untuk kalkulasi rata-rata
    SELECT purchasePrice, stockQuantity 
    INTO v_current_purchase_price, v_current_stock
    FROM items 
    WHERE itemsId = OLD.itemsId;
    
    -- Hitung harga rata-rata baru setelah penghapusan (reverse weighted average)
    IF v_current_stock - OLD.quantity > 0 THEN
        SET v_new_avg_price = ((v_current_purchase_price * v_current_stock) - (OLD.unitPrice * OLD.quantity)) 
                               / (v_current_stock - OLD.quantity);
    ELSE
        SET v_new_avg_price = 0;
    END IF;
    
    -- Update stok dan harga beli
    UPDATE items 
    SET 
        stockQuantity = stockQuantity - OLD.quantity,
        purchasePrice = ROUND(GREATEST(v_new_avg_price, 0), 2)
    WHERE itemsId = OLD.itemsId;
    
    -- Update moving status
    UPDATE items
    SET movingStatus = CASE
        WHEN (stockQuantity - OLD.quantity) > 100 THEN 'FAST'
        WHEN (stockQuantity - OLD.quantity) BETWEEN 20 AND 100 THEN 'SLOW'
        ELSE 'DEAD'
    END
    WHERE itemsId = OLD.itemsId;
    
    -- Update dailyProfitLoss (kurangi COGS)
    UPDATE dailyProfitLoss
    SET 
        dailyCOGS = dailyCOGS - OLD.totalPurchase,
        dailyGrossProfit = dailyRevenue - dailyCOGS
    WHERE businessId = OLD.businessId 
      AND summaryDate = DATE(OLD.inComingDate);
END$$

-- Trigger INSERT untuk logs
CREATE TRIGGER trg_inComingItems_after_insert
AFTER INSERT ON inComingItems
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
        'inComingItems',
        NEW.iciId,
        JSON_OBJECT(
            'itemsId', NEW.itemsId,
            'userId', NEW.userId,
            'quantity', NEW.quantity,
            'unitPrice', NEW.unitPrice,
            'totalPurchase', NEW.totalPurchase,
            'inComingDate', NEW.inComingDate
        )
    );
    
    -- Update dailyProfitLoss (tambah COGS)
    INSERT INTO dailyProfitLoss (
        businessId,
        summaryDate,
        dailyRevenue,
        dailyCOGS,
        dailyGrossProfit
    ) VALUES (
        NEW.businessId,
        DATE(NEW.inComingDate),
        0,
        NEW.totalPurchase,
        -NEW.totalPurchase
    )
    ON DUPLICATE KEY UPDATE
        dailyCOGS = dailyCOGS + NEW.totalPurchase,
        dailyGrossProfit = dailyRevenue - dailyCOGS;
END$$

-- Procedure untuk mendapatkan ranking stok
CREATE PROCEDURE GetStockRanking(
    IN p_businessId INT
)
BEGIN
    SELECT 
        RANK() OVER (ORDER BY stockQuantity DESC) AS peringkat,
        itemName AS nama_barang,
        category AS kategori,
        stockQuantity AS jumlah_stok,
        movingStatus AS status_pergerakan,
        FormatRupiah(purchasePrice) AS harga_beli,
        FormatRupiah(sellingPrice) AS harga_jual,
        FormatRupiah(stockQuantity * sellingPrice) AS nilai_stok_total
    FROM items
    WHERE businessId = p_businessId
    ORDER BY stockQuantity DESC;
END $$

-- Procedure utama untuk insert barang masuk
CREATE PROCEDURE InsertIncomingItem(
    IN p_itemsId INT,
    IN p_businessId INT,
    IN p_userId INT,
    IN p_quantity INT,
    IN p_unitPrice DECIMAL(15,2)
)
BEGIN
    DECLARE v_current_price DECIMAL(15,2);
    DECLARE v_new_avg_price DECIMAL(15,2);
    DECLARE v_current_stock INT;
    DECLARE v_total_purchase DECIMAL(15,2);
    DECLARE v_new_ici_id INT;
    DECLARE v_moving_status VARCHAR(10);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Lock row dan ambil data current
    SELECT purchasePrice, stockQuantity 
    INTO v_current_price, v_current_stock
    FROM items 
    WHERE itemsId = p_itemsId 
      AND businessId = p_businessId
    FOR UPDATE;
    
    IF v_current_price IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Item tidak ditemukan';
    END IF;
    
    -- Validasi input
    IF p_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Quantity harus lebih dari 0';
    END IF;
    
    IF p_unitPrice < 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Harga unit tidak boleh negatif';
    END IF;
    
    -- Hitung total purchase
    SET v_total_purchase = p_quantity * p_unitPrice;
    
    -- Hitung harga rata-rata baru (weighted average)
    IF v_current_stock + p_quantity > 0 THEN
        SET v_new_avg_price = ((v_current_price * v_current_stock) + (p_unitPrice * p_quantity)) 
                               / (v_current_stock + p_quantity);
    ELSE
        SET v_new_avg_price = p_unitPrice;
    END IF;
    
    -- Tentukan moving status baru
    SET v_moving_status = CASE
        WHEN (v_current_stock + p_quantity) > 100 THEN 'FAST'
        WHEN (v_current_stock + p_quantity) BETWEEN 20 AND 100 THEN 'SLOW'
        ELSE 'DEAD'
    END;
    
    -- Insert ke inComingItems
    INSERT INTO inComingItems (
        itemsId,
        businessId,
        userId,
        quantity,
        unitPrice,
        totalPurchase,
        inComingDate
    ) VALUES (
        p_itemsId,
        p_businessId,
        p_userId,
        p_quantity,
        p_unitPrice,
        v_total_purchase,
        NOW()
    );
    
    SET v_new_ici_id = LAST_INSERT_ID();
    
    -- Update items: stok, harga beli rata-rata, dan moving status
    UPDATE items 
    SET 
        stockQuantity = stockQuantity + p_quantity,
        purchasePrice = ROUND(v_new_avg_price, 2),
        movingStatus = v_moving_status
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
        0,
        v_total_purchase,
        -v_total_purchase
    )
    ON DUPLICATE KEY UPDATE
        dailyCOGS = dailyCOGS + v_total_purchase,
        dailyGrossProfit = dailyRevenue - dailyCOGS;
    
    COMMIT;
    
    -- Return hasil
    SELECT 
        'SUCCESS' AS status,
        'Barang masuk berhasil' AS message,
        v_new_ici_id AS incoming_id,
        v_current_stock AS stock_before,
        (v_current_stock + p_quantity) AS stock_after,
        FORMAT(v_current_price, 2) AS old_price,
        FORMAT(v_new_avg_price, 2) AS new_avg_price,
        FORMAT(p_unitPrice, 2) AS input_price,
        v_moving_status AS moving_status,
        FormatRupiah(v_total_purchase) AS total_purchase;
END$$

DELIMITER ;