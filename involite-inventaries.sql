-- Inventaries
CREATE TABLE inventaries (
    invId INT AUTO_INCREMENT PRIMARY KEY,
    businessId INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(200) NOT NULL,
    price DECIMAL(15,2) DEFAULT 0, 
    purchaseDate DATE NOT NULL,
    status ENUM('active','inactive') NOT NULL DEFAULT 'active',

    CONSTRAINT fk_inventaries_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DELIMITER $$

CREATE TRIGGER trg_inventaries_after_insert
AFTER INSERT ON inventaries
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
        'inventaries',
        NEW.invId,
        JSON_OBJECT(
            'name', NEW.name,
            'description', NEW.description,
            'price', NEW.price,
            'purchaseDate', NEW.purchaseDate,
            'status', NEW.status
        )
    );
END $$

CREATE TRIGGER trg_inventaries_after_update
AFTER UPDATE ON inventaries
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
        'inventaries',
        NEW.invId,
        JSON_OBJECT(
            'name', JSON_OBJECT('old', OLD.name, 'new', NEW.name),
            'description', JSON_OBJECT('old', OLD.description, 'new', NEW.description),
            'price', JSON_OBJECT('old', OLD.price, 'new', NEW.price),
            'purchaseDate', JSON_OBJECT('old', OLD.purchaseDate, 'new', NEW.purchaseDate),
            'status', JSON_OBJECT('old', OLD.status, 'new', NEW.status)
        )
    );
END $$

CREATE TRIGGER trg_inventaries_before_delete
BEFORE DELETE ON inventaries
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
        'inventaries',
        OLD.invId,
        JSON_OBJECT(
            'name', OLD.name,
            'description', OLD.description,
            'price', OLD.price,
            'purchaseDate', OLD.purchaseDate,
            'status', OLD.status
        )
    );
END $$

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
END $$

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
END $$

CREATE TRIGGER trg_check_inventary_price
BEFORE INSERT ON inventaries
FOR EACH ROW
BEGIN
    IF NEW.price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Harga inventaris harus lebih dari 0';
    END IF;
END $$

DELIMITER ;

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