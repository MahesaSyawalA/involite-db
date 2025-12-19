CREATE PROCEDURE GetBusinessItemProfitLoss(
    IN p_businessId INT,
    IN p_startDate DATE,  -- NULL untuk semua data
    IN p_endDate DATE     -- NULL untuk semua data
)
BEGIN
    -- Query dengan kondisi fleksibel
    WITH profit_data AS (
        SELECT 
            i.itemsId,
            i.itemName,
            i.category,
            i.stockQuantity,
            i.movingStatus,
            
            -- Data pembelian dengan kondisi fleksibel
            COALESCE(SUM(CASE 
                WHEN p_startDate IS NULL AND p_endDate IS NULL THEN ici.quantity
                WHEN ici.inComingDate BETWEEN p_startDate AND DATE_ADD(p_endDate, INTERVAL 1 DAY)
                THEN ici.quantity 
            END), 0) AS total_pembelian_qty,
            
            COALESCE(SUM(CASE 
                WHEN p_startDate IS NULL AND p_endDate IS NULL THEN ici.totalPurchase
                WHEN ici.inComingDate BETWEEN p_startDate AND DATE_ADD(p_endDate, INTERVAL 1 DAY)
                THEN ici.totalPurchase 
            END), 0) AS total_modal,
            
            -- Data penjualan dengan kondisi fleksibel
            COALESCE(SUM(CASE 
                WHEN p_startDate IS NULL AND p_endDate IS NULL THEN oci.quantity
                WHEN oci.outComingDate BETWEEN p_startDate AND DATE_ADD(p_endDate, INTERVAL 1 DAY)
                THEN oci.quantity 
            END), 0) AS total_penjualan_qty,
            
            COALESCE(SUM(CASE 
                WHEN p_startDate IS NULL AND p_endDate IS NULL THEN oci.totalSale
                WHEN oci.outComingDate BETWEEN p_startDate AND DATE_ADD(p_endDate, INTERVAL 1 DAY)
                THEN oci.totalSale 
            END), 0) AS total_penjualan
            
        FROM items i
        
        LEFT JOIN inComingItems ici ON i.itemsId = ici.itemsId 
            AND i.businessId = ici.businessId
            AND ici.businessId = p_businessId
            AND (p_startDate IS NULL OR ici.inComingDate >= p_startDate)
            AND (p_endDate IS NULL OR ici.inComingDate <= DATE_ADD(p_endDate, INTERVAL 1 DAY))
        
        LEFT JOIN outComingItems oci ON i.itemsId = oci.itemsId 
            AND i.businessId = oci.businessId
            AND oci.businessId = p_businessId
            AND (p_startDate IS NULL OR oci.outComingDate >= p_startDate)
            AND (p_endDate IS NULL OR oci.outComingDate <= DATE_ADD(p_endDate, INTERVAL 1 DAY))
            
        WHERE i.businessId = p_businessId
        
        GROUP BY i.itemsId, i.itemName, i.category, i.stockQuantity, i.movingStatus
    )
    
    SELECT 
        itemsId AS id_barang,
        itemName AS nama_barang,
        category AS kategori,
        stockQuantity AS stok_sekarang,
        movingStatus AS status_pergerakan,
        
        total_pembelian_qty,
        total_penjualan_qty,
        
        FormatRupiah(total_modal) AS total_modal,
        FormatRupiah(total_penjualan) AS total_penjualan,
        
        -- Laba kotor
        FormatRupiah(total_penjualan - total_modal) AS laba_kotor,
        
        -- Informasi periode
        CASE 
            WHEN p_startDate IS NULL THEN 'Semua Periode'
            ELSE CONCAT('Periode: ', p_startDate, ' s/d ', p_endDate)
        END AS periode_analisis
        
    FROM profit_data
    
    WHERE total_pembelian_qty > 0 OR total_penjualan_qty > 0
    
    ORDER BY (total_penjualan - total_modal) DESC;
END

-- contoh penggunaan
CALL GetBusinessItemProfitLossFlexible(1, NULL, NULL);  -- Semua data
CALL GetBusinessItemProfitLossFlexible(1, '2024-01-01', '2024-01-31');
