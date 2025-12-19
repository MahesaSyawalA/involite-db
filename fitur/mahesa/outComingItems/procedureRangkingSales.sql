CREATE PROCEDURE GetBestSellingItems(
    IN p_businessId INT
)
BEGIN
    SELECT 
        RANK() OVER (ORDER BY SUM(oci.quantity) DESC) AS ranking,
        i.itemName AS nama_barang,
        i.category AS kategori,
        SUM(oci.quantity) AS total_terjual,
        COUNT(oci.ociId) AS jumlah_transaksi,
        FORMAT(AVG(oci.unitPrice), 0) AS harga_rata_rata,
        FormatRupiah(SUM(oci.totalSale)) AS total_penjualan
    FROM outComingItems oci
    JOIN items i ON oci.itemsId = i.itemsId
    WHERE oci.businessId = p_businessId
    GROUP BY i.itemsId, i.itemName, i.category
    ORDER BY total_terjual DESC;
END