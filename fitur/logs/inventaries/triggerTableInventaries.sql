DELIMITER //

-- ===============================
-- TRIGGER: AFTER INSERT
-- ===============================
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
END //

-- ===============================
-- TRIGGER: AFTER UPDATE
-- ===============================

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
END //

-- ===============================
-- TRIGGER: BEFORE DELETE
-- ===============================
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
END //

DELIMITER ;
