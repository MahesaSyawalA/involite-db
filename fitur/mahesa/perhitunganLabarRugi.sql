CREATE TABLE dailyProfitoss (
    dailyId INT AUTO_INCREMENT PRIMARY KEY,
    businessId INT NOT NULL,
    summaryDate DATE NOT NULL,
    dailyRevenue DECIMAL(15,2) DEFAULT 0,
    dailyCOGS DECIMAL(15,2) DEFAULT 0,
    dailyGrossProfit DECIMAL(15,2) DEFAULT 0,
    UNIQUE KEY (businessId, summaryDate),
    FOREIGN KEY (businessId) REFERENCES business(businessId)
);

-- FUNCTION 1: Hitung profit
CREATE FUNCTION HitungProfit(
    harga_jual DECIMAL(15,2),
    harga_beli DECIMAL(15,2)
) 
RETURNS DECIMAL(15,2)
BEGIN
    RETURN harga_jual - harga_beli;
END

-- FUNCTION 2: Status profit
CREATE FUNCTION StatusProfit(
    profit DECIMAL(15,2)
)
RETURNS VARCHAR(20)
BEGIN
    IF profit > 0 THEN
        RETURN 'UNTUNG';
    ELSEIF profit < 0 THEN
        RETURN 'RUGI';
    ELSE
        RETURN 'BREAK EVEN';
    END IF;
END

-- PROCEDURE 1: Laporan Harian
CREATE PROCEDURE LaporanHarian(
    IN id_business INT,
    IN tanggal DATE
)
BEGIN
    SELECT 
        summaryDate AS tanggal,
        dailyRevenue AS pendapatan,
        dailyCOGS AS biaya,
        dailyGrossProfit AS profit,
        StatusProfit(dailyGrossProfit) AS status
    FROM dailyProfitoss
    WHERE businessId = id_business 
        AND summaryDate = tanggal;
END

-- PROCEDURE 2: Laporan Bulanan
CREATE PROCEDURE LaporanBulanan(
    IN id_business INT,
    IN tahun INT,
    IN bulan INT
)
BEGIN
    SELECT 
        DATE_FORMAT(summaryDate, '%Y-%m') AS periode,
        SUM(dailyRevenue) AS total_pendapatan,
        SUM(dailyCOGS) AS total_biaya,
        SUM(dailyGrossProfit) AS total_profit,
        COUNT(*) AS hari_aktif,
        StatusProfit(SUM(dailyGrossProfit)) AS status
    FROM dailyProfitoss
    WHERE businessId = id_business 
        AND YEAR(summaryDate) = tahun 
        AND MONTH(summaryDate) = bulan
    GROUP BY DATE_FORMAT(summaryDate, '%Y-%m');
END

-- PROCEDURE 3: Ranking Produk
CREATE PROCEDURE RankingProduk(
    IN id_business INT
)
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY jumlah_terjual DESC) AS peringkat,
        nama_barang,
        jumlah_terjual,
        total_penjualan
    FROM (
        SELECT 
            i.itemName AS nama_barang,
            SUM(oci.quantity) AS jumlah_terjual,
            SUM(oci.totalSale) AS total_penjualan
        FROM outComingItems oci
        JOIN items i ON oci.itemsId = i.itemsId
        WHERE oci.businessId = id_business
        GROUP BY i.itemName
    ) AS data_produk
    ORDER BY jumlah_terjual DESC
    LIMIT 5;
END

-- PROCEDURE 4: Proses Penjualan
CREATE PROCEDURE jual_barang(
    usaha_id INT,
    user_id INT,
    barang_id INT,
    qty INT,
    harga_jual DECIMAL
)
BEGIN
    DECLARE stok INT;
    DECLARE nama VARCHAR(150);
    DECLARE harga_beli DECIMAL;
    
    -- Cek stok
    SELECT stockQuantity, itemName, purchasePrice 
    INTO stok, nama, harga_beli
    FROM items 
    WHERE itemsId = barang_id;
    
    IF stok >= qty THEN
        -- Mulai transaksi
        START TRANSACTION;
        
        -- 1. Catat penjualan
        INSERT INTO outComingItems 
        (itemsId, businessId, userId, quantity, unitPrice)
        VALUES (barang_id, usaha_id, user_id, qty, harga_jual);
        
        -- 2. Update stok
        UPDATE items 
        SET stockQuantity = stockQuantity - qty
        WHERE itemsId = barang_id;
        
        -- 3. Update profit
        INSERT INTO dailyProfitoss 
        (businessId, summaryDate, dailyRevenue, dailyCOGS, dailyGrossProfit)
        VALUES (
            usaha_id, CURDATE(),
            qty * harga_jual,
            qty * harga_beli,
            (qty * harga_jual) - (qty * harga_beli)
        )
        ON DUPLICATE KEY UPDATE
            dailyRevenue = dailyRevenue + (qty * harga_jual),
            dailyCOGS = dailyCOGS + (qty * harga_beli),
            dailyGrossProfit = dailyGrossProfit + ((qty * harga_jual) - (qty * harga_beli));
        
        COMMIT;
        SELECT 'Penjualan berhasil' AS hasil;
    ELSE
        SELECT 'Stok tidak cukup' AS hasil;
    END IF;
    
END 

-- view dashboard_sederhana
CREATE VIEW dashboard_sederhana AS
SELECT 
    b.businessId,
    b.businessName,
    b.ownerName,
    
    -- Total penjualan bulan ini
    (SELECT COALESCE(SUM(totalSale), 0) 
     FROM outComingItems 
     WHERE businessId = b.businessId 
        AND MONTH(outComingDate) = MONTH(CURDATE())
        AND YEAR(outComingDate) = YEAR(CURDATE())
    ) AS penjualan_bulan_ini,
    
    -- Total profit bulan ini
    (SELECT COALESCE(SUM(dailyGrossProfit), 0) 
     FROM dailyProfitoss 
     WHERE businessId = b.businessId 
        AND MONTH(summaryDate) = MONTH(CURDATE())
        AND YEAR(summaryDate) = YEAR(CURDATE())
    ) AS profit_bulan_ini,
    
    -- Jumlah barang
    (SELECT COUNT(*) FROM items WHERE businessId = b.businessId) AS total_barang,
    
    -- Jumlah stok rendah
    (SELECT COUNT(*) FROM items WHERE businessId = b.businessId AND stockQuantity < 10) AS stok_rendah
    
FROM business b;