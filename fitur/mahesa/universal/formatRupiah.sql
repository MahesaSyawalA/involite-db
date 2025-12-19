CREATE FUNCTION FormatRupiah(
    amount DECIMAL(15,2)
)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE formatted VARCHAR(50);
    
    IF amount IS NULL THEN
        RETURN 'Rp 0';
    END IF;
    
    SET formatted = CONCAT('Rp ', FORMAT(amount, 0));
    
    RETURN formatted;
END