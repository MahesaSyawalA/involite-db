CREATE PROCEDURE GetStockRanking(
    IN p_businessId INT
)
BEGIN
    SELECT 
        RANK() OVER (ORDER BY stockQuantity DESC) AS peringkat,
        itemName AS nama_barang,
        category AS kategori,
        stockQuantity AS jumlah_stok,
        movingStatus AS status_pergerakan,
        FormatRupiah(purchasePrice) AS harga_beli,
        FormatRupiah(sellingPrice) AS harga_jual,
        FormatRupiah(stockQuantity * sellingPrice) AS nilai_stok_total
    FROM items
    WHERE businessId = p_businessId
    ORDER BY stockQuantity DESC;
END
