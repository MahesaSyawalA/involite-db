CREATE PROCEDURE GetTopRevenueMonths(
    IN p_businessId INT,
    IN p_year INT
)
BEGIN
    SELECT 
        RANK() OVER (ORDER BY SUM(dailyRevenue) DESC) AS ranking,
        MONTH(summaryDate) AS bulan_angka,
        DATE_FORMAT(summaryDate, '%M') AS nama_bulan,
        COUNT(*) AS hari_aktif,
        FormatRupiah(SUM(dailyRevenue)) AS total_pendapatan,
        FormatRupiah(SUM(dailyGrossProfit)) AS total_laba_kotor,
        CONCAT(FORMAT(AVG(dailyGrossProfit / NULLIF(dailyRevenue, 0)) * 100, 1), '%') AS margin_rata_rata
    FROM dailyProfitLoss
    WHERE businessId = p_businessId
      AND YEAR(summaryDate) = p_year
    GROUP BY MONTH(summaryDate), DATE_FORMAT(summaryDate, '%M')
    ORDER BY SUM(dailyRevenue) DESC;
END

-- contoh 
CALL GetTopRevenueMonths(1, 2024);
