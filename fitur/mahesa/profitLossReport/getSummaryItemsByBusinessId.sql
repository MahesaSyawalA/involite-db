CREATE PROCEDURE GetBusinessItemProfitLoss(IN p_businessId INT)
BEGIN
    -- Query dasar tanpa format (untuk kalkulasi)
    WITH profit_data AS (
        SELECT 
            i.itemsId,
            i.itemName,
            i.category,
            i.stockQuantity,
            i.movingStatus,
            i.purchasePrice,
            i.sellingPrice,
            
            -- Data pembelian
            COALESCE(SUM(ici.quantity), 0) AS total_pembelian_qty,
            COALESCE(SUM(ici.totalPurchase), 0) AS total_modal,
            
            -- Data penjualan
            COALESCE(SUM(oci.quantity), 0) AS total_penjualan_qty,
            COALESCE(SUM(oci.totalSale), 0) AS total_penjualan,
            
            -- Harga terakhir pembelian
            COALESCE((
                SELECT ici.unitPrice 
                FROM inComingItems ici 
                WHERE ici.itemsId = i.itemsId 
                AND ici.businessId = i.businessId
                ORDER BY ici.inComingDate DESC 
                LIMIT 1
            ), i.purchasePrice) AS harga_terakhir_beli
            
        FROM items i
        
        LEFT JOIN inComingItems ici ON i.itemsId = ici.itemsId 
            AND i.businessId = ici.businessId
            AND ici.businessId = p_businessId
        
        LEFT JOIN outComingItems oci ON i.itemsId = oci.itemsId 
            AND i.businessId = oci.businessId
            AND oci.businessId = p_businessId
            
        WHERE i.businessId = p_businessId
        
        GROUP BY i.itemsId, i.itemName, i.category, i.stockQuantity, 
                 i.movingStatus, i.purchasePrice, i.sellingPrice
    )
    
    SELECT 
        itemsId AS id_barang,
        itemName AS nama_barang,
        category AS kategori,
        stockQuantity AS stok_sekarang,
        movingStatus AS status_pergerakan,
        
        -- Data kuantitas
        total_pembelian_qty,
        total_penjualan_qty,
        
        -- Data keuangan dengan format Rupiah
        FormatRupiah(total_modal) AS total_modal,
        FormatRupiah(total_penjualan) AS total_penjualan,
        
        -- Nilai persediaan sekarang
        FormatRupiah(stockQuantity * harga_terakhir_beli) AS nilai_persediaan_sekarang,
        
        -- Laba kotor
        FormatRupiah(total_penjualan - total_modal) AS laba_kotor,
        
        -- Persentase laba
        CASE 
            WHEN total_modal > 0 
            THEN CONCAT(ROUND(((total_penjualan - total_modal) / total_modal) * 100, 2), '%')
            ELSE '0%'
        END AS persentase_laba,
        
        -- Status laba
        CASE 
            WHEN (total_penjualan - total_modal) > 0 THEN 'UNTUNG'
            WHEN (total_penjualan - total_modal) < 0 THEN 'RUGI'
            ELSE 'BREAK EVEN'
        END AS status_laba,
        
        -- Margin per unit
        CASE 
            WHEN purchasePrice > 0 
            THEN FormatRupiah(sellingPrice - purchasePrice)
            ELSE 'Rp 0'
        END AS margin_per_unit,
        
        -- ROI (Return on Investment)
        CASE 
            WHEN total_modal > 0 
            THEN CONCAT(ROUND((total_penjualan / total_modal) * 100, 2), '%')
            ELSE '0%'
        END AS roi
        
    FROM profit_data
    
    ORDER BY (total_penjualan - total_modal) DESC;
END 