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
        ON DELETE RESTRICT,

    CONSTRAINT fk_ici_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_ici_user
        FOREIGN KEY (userId)
        REFERENCES users(userId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

DELIMITER $$ 

-- Trigger: trg_inComingItems_after_update
CREATE TRIGGER trg_inComingItems_after_update
AFTER UPDATE ON inComingItems
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
END$$

-- Trigger: trg_inComingItems_before_delete
CREATE TRIGGER trg_inComingItems_before_delete
BEFORE DELETE ON inComingItems
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
END$$

-- Trigger: trg_inComingItems_after_insert
CREATE TRIGGER trg_inComingItems_after_insert
AFTER INSERT ON inComingItems
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
        'CREATE',
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
END$$

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
END$$

-- Trigger Update Stok Saat Barang Masuk
CREATE TRIGGER UpdateStockAfterIncoming
AFTER INSERT ON inComingItems
FOR EACH ROW
BEGIN
    -- Update stok di tabel items
    UPDATE items 
    SET stockQuantity = stockQuantity + NEW.quantity
    WHERE itemsId = NEW.itemsId;
END$$

-- trigger untuk mengkalkulasi profit harian 
CREATE TRIGGER trg_after_incomingitems_insert
AFTER INSERT ON inComingItems
FOR EACH ROW
BEGIN
    DECLARE v_summaryDate DATE;

    -- Ambil tanggal transaksi
    SET v_summaryDate = DATE(NEW.inComingDate);

    -- Jika data harian sudah ada → UPDATE
    IF EXISTS (
        SELECT 1 
        FROM dailyProfitLoss 
        WHERE businessId = NEW.businessId 
          AND summaryDate = v_summaryDate
    ) THEN

        UPDATE dailyProfitLoss
        SET 
            dailyCOGS = dailyCOGS + NEW.totalPurchase,
            dailyGrossProfit = dailyRevenue - (dailyCOGS + NEW.totalPurchase)
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
            0,
            NEW.totalPurchase,
            0 - NEW.totalPurchase
        );

    END IF;
END$$

CREATE TRIGGER RestoreStockAfterIncomingDelete
AFTER DELETE ON inComingItems
FOR EACH ROW
BEGIN
    -- Kembalikan stok ke jumlah semula (dikurangi)
    UPDATE items 
    SET stockQuantity = stockQuantity - OLD.quantity
    WHERE itemsId = OLD.itemsId;
    
    -- Update moving status berdasarkan stok baru
    UPDATE items
    SET movingStatus = CASE
        WHEN (stockQuantity - OLD.quantity) > 100 THEN 'FAST'
        WHEN (stockQuantity - OLD.quantity) BETWEEN 20 AND 100 THEN 'SLOW'
        ELSE 'DEAD'
    END
    WHERE itemsId = OLD.itemsId;
END$$

CREATE TRIGGER trg_after_incomingitems_delete
AFTER DELETE ON inComingItems
FOR EACH ROW
BEGIN
    DECLARE v_summaryDate DATE;

    -- Ambil tanggal transaksi lama
    SET v_summaryDate = DATE(OLD.inComingDate);

    -- Update dailyProfitLoss dengan mengurangi COGS
    IF EXISTS (
        SELECT 1 
        FROM dailyProfitLoss 
        WHERE businessId = OLD.businessId 
          AND summaryDate = v_summaryDate
    ) THEN

        UPDATE dailyProfitLoss
        SET 
            dailyCOGS = dailyCOGS - OLD.totalPurchase,
            dailyGrossProfit = dailyRevenue - (dailyCOGS - OLD.totalPurchase)
        WHERE businessId = OLD.businessId
          AND summaryDate = v_summaryDate;

    END IF;
END$$
DELIMITER ;