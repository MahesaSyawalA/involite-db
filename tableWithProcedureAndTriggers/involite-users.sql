CREATE TABLE users (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    businessId INT NOT NULL,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100),
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    role ENUM('owner','akuntan','gudang','sales') NOT NULL,

    CONSTRAINT fk_users_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DELIMITER $$

CREATE TRIGGER trg_users_after_insert
AFTER INSERT ON users
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
        'users',
        NEW.userId,
        JSON_OBJECT(
            'firstName', NEW.firstName,
            'lastName', NEW.lastName,
            'email', NEW.email,
            'phone', NEW.phone,
            'role', NEW.role
        )
    );
END $$

CREATE TRIGGER trg_users_after_update
AFTER UPDATE ON users
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
        'users',
        NEW.userId,
        JSON_OBJECT(
            'firstName', JSON_OBJECT('old', OLD.firstName, 'new', NEW.firstName),
            'lastName',  JSON_OBJECT('old', OLD.lastName,  'new', NEW.lastName),
            'email',     JSON_OBJECT('old', OLD.email,     'new', NEW.email),
            'phone',     JSON_OBJECT('old', OLD.phone,     'new', NEW.phone),
            'role',      JSON_OBJECT('old', OLD.role,      'new', NEW.role)
        )
    );
END $$

CREATE TRIGGER trg_users_before_delete
BEFORE DELETE ON users
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
        'users',
        OLD.userId,
        JSON_OBJECT(
            'firstName', OLD.firstName,
            'lastName', OLD.lastName,
            'email', OLD.email,
            'phone', OLD.phone,
            'role', OLD.role
        )
    );
END $$

DELIMITER ;