USE involite_db;

-- FUNCTION
-- Total stok barang (angka ringkasan dashboard)
SELECT fn_total_stock(1) AS total_stok;

-- PROCEDURE
-- Data utama dashboard barang
CALL sp_dashboard_informasi_barang(1);

-- PROCEDURE + TRANSACTION
-- Transaksi barang keluar (BERHASIL)
CALL sp_outcoming_item_transaction(1, 1, 2, 1);

-- PROCEDURE + TRANSACTION
-- Transaksi barang keluar (GAGAL - stok tidak cukup)
CALL sp_outcoming_item_transaction(1, 1, 9999, 1);

-- VIEW + RANKING
-- Peringkat barang berdasarkan stok
SELECT
    itemName,
    stockQuantity,
    stock_rank
FROM vw_item_stock_ranking
WHERE businessId = 1;

-- TRIGGER (PEMBUKTIAN)
-- Trigger otomatis menolak stok minus
INSERT INTO outComingItems (
    itemsId,
    businessId,
    userId,
    quantity,
    unitPrice,
    outComingDate
)
VALUES (1,1,1,9999,10000,NOW()
);