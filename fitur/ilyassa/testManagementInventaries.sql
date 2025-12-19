USE involite_db;

-- 1. TEST FUNCTION
SELECT fn_total_inventary_value(1) AS total_inventory_value;

-- 2. TEST PROCEDURE + TRANSACTION
CALL sp_add_inventary(
    1,
    'Rak Gudang Besi',
    'Rak penyimpanan stok gudang',
    3500000,
    '2024-01-15'
);

-- 3. CEK DATA HASIL INSERT
SELECT *
FROM inventaries
WHERE businessId = 1;

-- 4. TEST TRIGGER (HARUS ERROR)
INSERT INTO inventaries (
    businessId,
    name,
    description,
    price,
    purchaseDate,
    status
) VALUES (
    1,
    'Inventaris Rusak',
    'Harga salah',
    -1000,
    '2024-01-20',
    'active'
);

-- 5. TEST RANKING
SELECT *
FROM vw_inventary_ranking
WHERE businessId = 1;

-- 6. VIEW DASHBOARD INVENTARIES
SELECT *
FROM vw_dashboard_inventaries
WHERE businessId = 1;
