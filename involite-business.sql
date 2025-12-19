-- Table Business
CREATE TABLE business (
    businessId INT AUTO_INCREMENT PRIMARY KEY,
    businessName VARCHAR(150) NOT NULL,
    ownerName VARCHAR(100) NOT NULL,
    businessType VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    phoneNumber VARCHAR(20) NOT NULL
);

DELIMITER $$

CREATE TRIGGER trg_business_after_insert
AFTER INSERT ON business
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
        'business',
        NEW.businessId,
        JSON_OBJECT(
            'businessName', NEW.businessName,
            'ownerName', NEW.ownerName,
            'businessType', NEW.businessType,
            'address', NEW.address,
            'phoneNumber', NEW.phoneNumber
        )
    );
END$$


CREATE TRIGGER trg_business_after_update
AFTER UPDATE ON business
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
        'business',
        NEW.businessId,
        JSON_OBJECT(
            'businessName', JSON_OBJECT('old', OLD.businessName, 'new', NEW.businessName),
            'ownerName', JSON_OBJECT('old', OLD.ownerName, 'new', NEW.ownerName),
            'businessType', JSON_OBJECT('old', OLD.businessType, 'new', NEW.businessType),
            'address', JSON_OBJECT('old', OLD.address, 'new', NEW.address),
            'phoneNumber', JSON_OBJECT('old', OLD.phoneNumber, 'new', NEW.phoneNumber)
        )
    );
END$$


CREATE TRIGGER trg_business_before_delete
BEFORE DELETE ON business
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
        'business',
        OLD.businessId,
        JSON_OBJECT(
            'businessName', OLD.businessName,
            'ownerName', OLD.ownerName,
            'businessType', OLD.businessType,
            'address', OLD.address,
            'phoneNumber', OLD.phoneNumber
        )
    );
END$$

DELIMITER ;