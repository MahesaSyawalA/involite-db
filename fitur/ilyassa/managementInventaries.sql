USE involite_db;

-- FUNCTION
-- Hitung total nilai inventaris aktif per business
DELIMITER //

CREATE FUNCTION fn_total_inventary_value(p_businessId INT)
RETURNS BIGINT
DETERMINISTIC
BEGIN
    DECLARE total BIGINT;

    SELECT COALESCE(SUM(price), 0)
    INTO total
    FROM inventaries
    WHERE businessId = p_businessId
      AND status = 'active';

    RETURN total;
END//

DELIMITER ;

-- PROCEDURE + TRANSACTION
-- Tambah inventaris baru (aman dengan transaction)
DELIMITER //

CREATE PROCEDURE sp_add_inventary(
    IN p_businessId INT,
    IN p_name VARCHAR(150),
    IN p_description VARCHAR(200),
    IN p_price INT,
    IN p_purchaseDate DATE
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO inventaries (
        businessId,
        name,
        description,
        price,
        purchaseDate,
        status
    ) VALUES (
        p_businessId,
        p_name,
        p_description,
        p_price,
        p_purchaseDate,
        'active'
    );

    COMMIT;
END//

DELIMITER ;

-- TRIGGER
-- Validasi harga inventaris
DELIMITER //
CREATE TRIGGER trg_check_inventary_price
BEFORE INSERT ON inventaries
FOR EACH ROW
BEGIN
    IF NEW.price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Harga inventaris harus lebih dari 0';
    END IF;
END//
DELIMITER ;

-- VIEW + RANKING
-- Ranking inventaris berdasarkan harga
CREATE VIEW vw_inventary_ranking AS
SELECT
    invId,
    businessId,
    name,
    price,
    RANK() OVER (
        PARTITION BY businessId
        ORDER BY price DESC
    ) AS price_rank
FROM inventaries
WHERE status = 'active';

-- VIEW DASHBOARD INVENTARIES
CREATE VIEW vw_dashboard_inventaries AS
SELECT
    invId,
    businessId,
    name,
    description,
    price,
    purchaseDate,
    status
FROM inventaries
WHERE status = 'active';