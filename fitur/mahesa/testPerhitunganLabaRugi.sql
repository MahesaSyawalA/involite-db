-- 1. Test FUNCTION
SELECT 
    itemName,
    sellingPrice,
    purchasePrice,
    HitungProfit(sellingPrice, purchasePrice) AS profit_per_item,
    StatusProfit(HitungProfit(sellingPrice, purchasePrice)) AS status
FROM items 
WHERE businessId = 1 
LIMIT 3;

-- 2. Test PROCEDURE Laporan Harian
CALL LaporanHarian(1, '2025-01-01');

-- 3. Test PROCEDURE Laporan Bulanan
CALL LaporanBulanan(1, 2025, 1);

-- 4. Test PROCEDURE Ranking Produk
CALL RankingProduk(1);

-- 5. Test PROCEDURE Proses Penjualan
CALL ProsesPenjualan(1, 4, 1, 2, 72000);

-- 6. Lihat hasil
SELECT * FROM outComingItems ORDER BY ociId DESC LIMIT 1;
SELECT * FROM items WHERE itemsId = 1;
SELECT * FROM dailyProfitoss WHERE businessId = 1 ORDER BY summaryDate DESC;