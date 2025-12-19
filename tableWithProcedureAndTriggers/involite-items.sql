CREATE TABLE items (
    itemsId INT AUTO_INCREMENT PRIMARY KEY,
    businessId INT NOT NULL, 
    itemName VARCHAR(150) NOT NULL, 
    category VARCHAR(100) NOT NULL, 
    purchasePrice DECIMAL(12,2) DEFAULT 0, 
    sellingPrice DECIMAL(12,2) DEFAULT 0, 
    stockQuantity INT NOT NULL, 
    movingStatus ENUM('FAST','SLOW','DEAD') NOT NULL,

    CONSTRAINT fk_items_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE CASCADE 
);

DELIMITER $$

CREATE TRIGGER trg_items_after_insert
AFTER INSERT ON items
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
        'items',
        NEW.itemsId,
        JSON_OBJECT(
            'itemName', NEW.itemName,
            'category', NEW.category,
            'purchasePrice', NEW.purchasePrice,
            'sellingPrice', NEW.sellingPrice,
            'stockQuantity', NEW.stockQuantity,
            'movingStatus', NEW.movingStatus
        )
    );
END$$

CREATE TRIGGER trg_items_after_update
AFTER UPDATE ON items
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
        'items',
        NEW.itemsId,
        JSON_OBJECT(
            'itemName', JSON_OBJECT('old', OLD.itemName, 'new', NEW.itemName),
            'category', JSON_OBJECT('old', OLD.category, 'new', NEW.category),
            'purchasePrice', JSON_OBJECT('old', OLD.purchasePrice, 'new', NEW.purchasePrice),
            'sellingPrice', JSON_OBJECT('old', OLD.sellingPrice, 'new', NEW.sellingPrice),
            'stockQuantity', JSON_OBJECT('old', OLD.stockQuantity, 'new', NEW.stockQuantity),
            'movingStatus', JSON_OBJECT('old', OLD.movingStatus, 'new', NEW.movingStatus)
        )
    );
END$$

CREATE TRIGGER trg_items_before_delete
BEFORE DELETE ON items
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
        'items',
        OLD.itemsId,
        JSON_OBJECT(
            'itemName', OLD.itemName,
            'category', OLD.category,
            'purchasePrice', OLD.purchasePrice,
            'sellingPrice', OLD.sellingPrice,
            'stockQuantity', OLD.stockQuantity,
            'movingStatus', OLD.movingStatus
        )
    );
END$$

DELIMITER ;