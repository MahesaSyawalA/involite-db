CREATE TABLE dailyProfitLoss (
    dailyId INT AUTO_INCREMENT PRIMARY KEY,
    businessId INT NOT NULL,
    summaryDate DATE NOT NULL,
    dailyRevenue DECIMAL(15,2) DEFAULT 0,
    dailyCOGS DECIMAL(15,2) DEFAULT 0,
    dailyGrossProfit DECIMAL(15,2) DEFAULT 0,
    UNIQUE KEY (businessId, summaryDate),
    FOREIGN KEY (businessId) REFERENCES business(businessId)
);

DELIMITER $$
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
END $$

CREATE PROCEDURE GetMonthlyRecap(
    IN p_businessId INT,
    IN p_month INT,   
    IN p_year INT       
)
BEGIN
    DECLARE v_month_name VARCHAR(20);
    DECLARE v_total_days INT;
    DECLARE v_operational_days INT;
    
    -- Get month name
    SET v_month_name = DATE_FORMAT(CONCAT(p_year, '-', p_month, '-01'), '%M');
    
    -- Calculate total days in month
    SET v_total_days = DAY(LAST_DAY(CONCAT(p_year, '-', p_month, '-01')));
    
    SELECT 
        -- Informasi Periode
        CONCAT(v_month_name, ' ', p_year) AS periode,
        p_month AS bulan_angka,
        v_month_name AS nama_bulan,
        p_year AS tahun,
        v_total_days AS total_hari_dalam_bulan,
        
        -- Statistik Hari
        COUNT(*) AS hari_operasional,
        CONCAT(FORMAT((COUNT(*) / v_total_days) * 100, 1), '%') AS persentase_operasional,
        
        -- Ringkasan Keuangan
        FormatRupiah(SUM(dailyRevenue)) AS total_pendapatan,
        FormatRupiah(SUM(dailyCOGS)) AS total_hpp,
        FormatRupiah(SUM(dailyGrossProfit)) AS total_laba_kotor,
        
        -- Rata-rata Harian
        FormatRupiah(AVG(dailyRevenue)) AS rata_rata_pendapatan_harian,
        FormatRupiah(AVG(dailyGrossProfit)) AS rata_rata_laba_harian,
        
        -- Nilai Tertinggi & Terendah
        FormatRupiah(MAX(dailyRevenue)) AS pendapatan_tertinggi,
        FormatRupiah(MIN(dailyRevenue)) AS pendapatan_terendah,
        FormatRupiah(MAX(dailyGrossProfit)) AS laba_tertinggi,
        FormatRupiah(MIN(dailyGrossProfit)) AS laba_terendah,
        
        -- Persentase
        CONCAT(FORMAT((SUM(dailyGrossProfit) / NULLIF(SUM(dailyRevenue), 0)) * 100, 1), '%') AS margin_bulanan,
        
        -- Perbandingan HPP vs Revenue
        CONCAT(FORMAT((SUM(dailyCOGS) / NULLIF(SUM(dailyRevenue), 0)) * 100, 1), '%') AS persentase_hpp
        
    FROM dailyProfitLoss
    WHERE businessId = p_businessId
      AND YEAR(summaryDate) = p_year
      AND MONTH(summaryDate) = p_month;
    
END $$
