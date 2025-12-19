USE involite_db;

-- FUNCTION
-- Total stok semua barang per bisnis (Dashboard Summary)
DELIMITER //

DROP FUNCTION IF EXISTS fn_total_stock;
CREATE FUNCTION fn_total_stock(p_businessId INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT IFNULL(SUM(stockQuantity), 0)
    INTO total
    FROM items
    WHERE businessId = p_businessId;

    RETURN total;
END//

DELIMITER ;

-- PROCEDURE
-- Data utama dashboard barang
DELIMITER //

DROP PROCEDURE IF EXISTS sp_dashboard_informasi_barang;
CREATE PROCEDURE sp_dashboard_informasi_barang (
    IN p_businessId INT
)
BEGIN
    SELECT
        i.itemsId,
        i.itemName,
        i.category,
        i.stockQuantity,
        i.movingStatus,
        i.sellingPrice
    FROM items i
    WHERE i.businessId = p_businessId;
END//

DELIMITER ;

-- PROCEDURE + TRANSACTION
-- Transaksi barang keluar (aman & atomic)
DELIMITER //

DROP PROCEDURE IF EXISTS sp_outcoming_item_transaction;
CREATE PROCEDURE sp_outcoming_item_transaction (
    IN p_businessId INT,
    IN p_itemsId INT,
    IN p_qty INT,
    IN p_userId INT
)
BEGIN
    DECLARE v_stock INT;

    START TRANSACTION;
    -- Lock data stok
    SELECT stockQuantity
    INTO v_stock
    FROM items
    WHERE itemsId = p_itemsId
      AND businessId = p_businessId
    FOR UPDATE;
    -- Item tidak ditemukan
    IF v_stock IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Item tidak ditemukan';
    END IF;
    -- Stok tidak cukup
    IF v_stock < p_qty THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stok tidak mencukupi';
    END IF;
    -- Update stok
    UPDATE items
    SET stockQuantity = stockQuantity - p_qty,
        movingStatus = 'FAST'
    WHERE itemsId = p_itemsId
      AND businessId = p_businessId;
    -- Catat barang keluar
    INSERT INTO outComingItems (
        itemsId,
        businessId,
        userId,
        quantity,
        unitPrice,
        outComingDate
    )
    VALUES (
        p_itemsId,
        p_businessId,
        p_userId,
        p_qty,
        (SELECT sellingPrice FROM items WHERE itemsId = p_itemsId),
        NOW()
    );
    COMMIT;
END//
DELIMITER ;

-- TRIGGER
-- Validasi stok sebelum insert barang keluar
DELIMITER //
DROP TRIGGER IF EXISTS trg_check_stock_before_out;
CREATE TRIGGER trg_check_stock_before_out
BEFORE INSERT ON outComingItems
FOR EACH ROW
BEGIN
    DECLARE currentStock INT;

    SELECT stockQuantity
    INTO currentStock
    FROM items
    WHERE itemsId = NEW.itemsId;
    IF currentStock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stok tidak mencukupi (Trigger)';
    END IF;
END//
DELIMITER ;

-- VIEW + RANKING
-- Peringkat barang berdasarkan stok per bisnis
CREATE OR REPLACE VIEW vw_item_stock_ranking AS
SELECT
    itemsId,
    businessId,
    itemName,
    stockQuantity,
    RANK() OVER (
        PARTITION BY businessId
        ORDER BY stockQuantity DESC
    ) AS stock_rank
FROM items;
