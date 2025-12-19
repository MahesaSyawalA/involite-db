CREATE PROCEDURE GetBusinessItemProfitLoss(IN p_businessId INT)
BEGIN
    SELECT 
        i.itemsId AS id_barang,
        i.itemName AS nama_barang,
        i.category AS kategori,
        i.stockQuantity AS stok_sekarang,
        i.movingStatus AS status_pergerakan,
        
        -- Informasi pembelian (modal)
        COALESCE(SUM(ici.quantity), 0) AS total_pembelian_qty,
        COALESCE(SUM(ici.totalPurchase), 0) AS total_modal,
        
        -- Informasi penjualan
        COALESCE(SUM(oci.quantity), 0) AS total_penjualan_qty,
        COALESCE(SUM(oci.totalSale), 0) AS total_penjualan,
        
        -- Informasi persediaan saat ini (dalam nilai)
        i.stockQuantity * COALESCE((
            SELECT ici.unitPrice 
            FROM inComingItems ici 
            WHERE ici.itemsId = i.itemsId 
            ORDER BY ici.inComingDate DESC 
            LIMIT 1
        ), i.purchasePrice) AS nilai_persediaan_sekarang,
        
        -- Perhitungan laba/rugi
        COALESCE(SUM(oci.totalSale), 0) - COALESCE(SUM(ici.totalPurchase), 0) AS laba_kotor,
        
        -- Persentase laba/rugi
        CASE 
            WHEN COALESCE(SUM(ici.totalPurchase), 0) > 0 
            THEN ROUND(((COALESCE(SUM(oci.totalSale), 0) - COALESCE(SUM(ici.totalPurchase), 0)) / COALESCE(SUM(ici.totalPurchase), 0)) * 100, 2)
            ELSE 0 
        END AS persentase_laba,
        
        -- Status laba/rugi
        CASE 
            WHEN (COALESCE(SUM(oci.totalSale), 0) - COALESCE(SUM(ici.totalPurchase), 0)) > 0 THEN 'UNTUNG'
            WHEN (COALESCE(SUM(oci.totalSale), 0) - COALESCE(SUM(ici.totalPurchase), 0)) < 0 THEN 'RUGI'
            ELSE 'BREAK EVEN'
        END AS status_laba
        
    FROM items i
    
    -- Left join untuk data pembelian
    LEFT JOIN inComingItems ici ON i.itemsId = ici.itemsId 
        AND i.businessId = ici.businessId
        AND ici.businessId = p_businessId
    
    -- Left join untuk data penjualan
    LEFT JOIN outComingItems oci ON i.itemsId = oci.itemsId 
        AND i.businessId = oci.businessId
        AND oci.businessId = p_businessId
        
    WHERE i.businessId = p_businessId
    
    GROUP BY i.itemsId, i.itemName, i.category, i.stockQuantity, i.movingStatus, i.purchasePrice
    
    ORDER BY laba_kotor DESC;
END 