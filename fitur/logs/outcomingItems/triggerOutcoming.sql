
-- Trigger: trg_outComingItems_after_update
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
END

-- Trigger: trg_outComingItems_before_delete
CREATE TRIGGER trg_outComingItems_before_delete
BEFORE DELETE ON outComingItems
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
END

-- Trigger: trg_outComingItems_after_insert
CREATE TRIGGER trg_outComingItems_after_insert
AFTER INSERT ON outComingItems
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
END