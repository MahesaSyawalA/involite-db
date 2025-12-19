
-- Total Nilai Barang Masuk
CREATE FUNCTION GetMonthlyIncomingValue(business_id INT, month_date DATE)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE total_value DECIMAL(15,2);
    
    SELECT COALESCE(SUM(totalPurchase), 0)
    INTO total_value
    FROM inComingItems
    WHERE businessId = business_id
    AND MONTH(inComingDate) = MONTH(month_date)
    AND YEAR(inComingDate) = YEAR(month_date);
    
    RETURN total_value;
END

-- Laporan Barang Masuk Harian
CREATE PROCEDURE GetDailyIncomingReport(
    IN business_id INT,
    IN report_date DATE
)
BEGIN
    SELECT 
        i.itemName,
        ici.quantity,
        ici.unitPrice,
        ici.totalPurchase,
        ici.inComingDate,
        CONCAT(u.firstName, ' ', COALESCE(u.lastName, '')) as enteredBy
    FROM inComingItems ici
    JOIN items i ON ici.itemsId = i.itemsId
    JOIN users u ON ici.userId = u.userId
    WHERE ici.businessId = business_id
    AND DATE(ici.inComingDate) = report_date
    ORDER BY ici.inComingDate DESC;
END

-- Rangking Berdasarkan Frekuensi Barang Masuk
SELECT 
    i.itemName,
    COUNT(ici.iciId) as incoming_frequency,
    SUM(ici.quantity) as total_quantity,
    RANK() OVER (ORDER BY COUNT(ici.iciId) DESC) as frequency_rank
FROM inComingItems ici
JOIN items i ON ici.itemsId = i.itemsId
WHERE ici.businessId = 1  -- Ganti dengan businessId yang diinginkan
AND ici.inComingDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY i.itemsId, i.itemName
ORDER BY frequency_rank
LIMIT 10;

-- Transaction Add Incoming Item
CREATE PROCEDURE AddIncomingItemTransaction(
    IN p_itemsId INT,
    IN p_businessId INT,
    IN p_userId INT,
    IN p_quantity INT,
    IN p_unitPrice DECIMAL(15,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- 1. Insert ke inComingItems
    INSERT INTO inComingItems (
        itemsId,
        businessId,
        userId,
        quantity,
        unitPrice,
        inComingDate
    ) VALUES (
        p_itemsId,
        p_businessId,
        p_userId,
        p_quantity,
        p_unitPrice,
        NOW()
    );
    
    -- 2. Update stok di items
    UPDATE items 
    SET stockQuantity = stockQuantity + p_quantity
    WHERE itemsId = p_itemsId
    AND businessId = p_businessId;
    
    -- 3. Update moving status berdasarkan stok baru
    UPDATE items
    SET movingStatus = CASE
        WHEN stockQuantity > 100 THEN 'FAST'
        WHEN stockQuantity BETWEEN 20 AND 100 THEN 'SLOW'
        ELSE 'DEAD'
    END
    WHERE itemsId = p_itemsId;
    
    COMMIT;
    
    SELECT 'Barang masuk berhasil dicatat' as message;
END