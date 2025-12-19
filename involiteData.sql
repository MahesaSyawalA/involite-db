-- business 
INSERT INTO business (businessName, ownerName, businessType, address, phoneNumber) VALUES
('Toko Sembako Berkah Jaya', 'Ahmad Fauzi', 'Retail Sembako', 'Jl. Raya Pasar Minggu No. 12, Jakarta Selatan', '081234567890'),
('Kopi Nusantara', 'Dewi Lestari', 'Kedai Kopi', 'Jl. Sudirman No. 45, Bandung', '082198765432'),
('Laundry Express Clean', 'Budi Santoso', 'Jasa Laundry', 'Jl. Melati No. 8, Yogyakarta', '085712345678'),
('Percetakan Maju Mandiri', 'Rina Putri', 'Jasa Percetakan', 'Jl. Diponegoro No. 22, Surabaya', '081398765432');

-- data dummy users
INSERT INTO users (businessId, firstName, lastName, email, phone, role) VALUES
-- BUSINESS ID 1
(1, 'Ahmad', 'Fauzi', 'ahmad.owner@berkahjaya.com', '081234567101', 'owner'),
(1, 'Siti', 'Rahmawati', 'siti.akuntan@berkahjaya.com', '081234567102', 'akuntan'),
(1, 'Rudi', 'Hartono', 'rudi.gudang@berkahjaya.com', '081234567103', 'gudang'),
(1, 'Andi', 'Saputra', 'andi.sales@berkahjaya.com', '081234567104', 'sales'),

-- BUSINESS ID 2
(2, 'Dewi', 'Lestari', 'dewi.owner@kopinusantara.com', '081234567201', 'owner'),
(2, 'Rina', 'Putri', 'rina.akuntan@kopinusantara.com', '081234567202', 'akuntan'),
(2, 'Bayu', 'Pratama', 'bayu.gudang@kopinusantara.com', '081234567203', 'gudang'),
(2, 'Fajar', 'Hidayat', 'fajar.sales@kopinusantara.com', '081234567204', 'sales'),

-- BUSINESS ID 3
(3, 'Budi', 'Santoso', 'budi.owner@cleanlaundry.com', '081234567301', 'owner'),
(3, 'Lina', 'Marlina', 'lina.akuntan@cleanlaundry.com', '081234567302', 'akuntan'),
(3, 'Agus', 'Wijaya', 'agus.gudang@cleanlaundry.com', '081234567303', 'gudang'),
(3, 'Doni', 'Kurniawan', 'doni.sales@cleanlaundry.com', '081234567304', 'sales'),

-- BUSINESS ID 4
(4, 'Rina', 'Putri', 'rina.owner@majumandiri.com', '081234567401', 'owner'),
(4, 'Yuni', 'Astuti', 'yuni.akuntan@majumandiri.com', '081234567402', 'akuntan'),
(4, 'Eko', 'Susanto', 'eko.gudang@majumandiri.com', '081234567403', 'gudang'),
(4, 'Arif', 'Setiawan', 'arif.sales@majumandiri.com', '081234567404', 'sales');

-- -- data dummy absen 
-- INSERT INTO employeePresence (userID, presenceDate, clockIN, clockOUT) VALUES
-- -- BUSINESS 1 (userId 1–4)
-- (1, CURDATE(), '08:00:00', '16:30:00'),
-- (2, CURDATE(), '08:10:00', '16:45:00'),
-- (3, CURDATE(), '08:05:00', NULL),
-- (4, CURDATE(), '08:20:00', '17:00:00'),

-- -- BUSINESS 2 (userId 5–8)
-- (5, CURDATE(), '08:00:00', '16:40:00'),
-- (6, CURDATE(), '08:15:00', '16:50:00'),
-- (7, CURDATE(), '08:05:00', NULL),
-- (8, CURDATE(), '08:30:00', '17:10:00'),

-- -- BUSINESS 3 (userId 9–12)
-- (9,  CURDATE(), '08:00:00', '16:30:00'),
-- (10, CURDATE(), '08:10:00', '16:45:00'),
-- (11, CURDATE(), '08:25:00', NULL),
-- (12, CURDATE(), '08:40:00', '17:15:00'),

-- -- BUSINESS 4 (userId 13–16)
-- (13, CURDATE(), '08:00:00', '16:30:00'),
-- (14, CURDATE(), '08:15:00', '16:50:00'),
-- (15, CURDATE(), '08:05:00', NULL),
-- (16, CURDATE(), '08:35:00', '17:20:00');


-- data dummy inventaries
INSERT INTO inventaries (businessId, name, description, price, purchaseDate, status) VALUES
-- BUSINESS ID 1
(1, 'Rak Besi', 'Rak besi penyimpanan barang', 750000, CURDATE(), 'active'),
(1, 'Timbangan Digital', 'Timbangan digital 30kg', 450000, CURDATE(), 'active'),
(1, 'Meja Kasir', 'Meja kasir kayu', 1200000, CURDATE(), 'active'),
(1, 'Kursi Plastik', 'Kursi plastik pelanggan', 85000, CURDATE(), 'active'),
(1, 'Etalase Kaca', 'Etalase kaca toko', 2500000, CURDATE(), 'active'),
(1, 'Printer Struk', 'Printer struk thermal', 650000, CURDATE(), 'active'),
(1, 'Lemari Penyimpanan', 'Lemari gudang besi', 1800000, CURDATE(), 'active'),
(1, 'Kalkulator', 'Kalkulator kasir', 95000, CURDATE(), 'active'),
(1, 'Lampu LED', 'Lampu LED toko', 120000, CURDATE(), 'active'),
(1, 'Kipas Angin', 'Kipas angin berdiri', 350000, CURDATE(), 'active'),

-- BUSINESS ID 2
(2, 'Mesin Espresso', 'Mesin kopi espresso', 8500000, CURDATE(), 'active'),
(2, 'Grinder Kopi', 'Mesin penggiling kopi', 3200000, CURDATE(), 'active'),
(2, 'Meja Bar', 'Meja bar kayu', 4200000, CURDATE(), 'active'),
(2, 'Kursi Bar', 'Kursi bar besi', 650000, CURDATE(), 'active'),
(2, 'Kulkas Minuman', 'Kulkas display minuman', 3800000, CURDATE(), 'active'),
(2, 'Teko Stainless', 'Teko kopi stainless', 180000, CURDATE(), 'active'),
(2, 'Timbangan Kopi', 'Timbangan kopi digital', 350000, CURDATE(), 'active'),
(2, 'Rak Gelas', 'Rak penyimpanan gelas', 950000, CURDATE(), 'active'),
(2, 'Mesin Kasir', 'Mesin kasir POS', 2800000, CURDATE(), 'active'),
(2, 'Blender', 'Blender minuman', 650000, CURDATE(), 'active'),

-- BUSINESS ID 3
(3, 'Mesin Cuci', 'Mesin cuci kapasitas besar', 5200000, CURDATE(), 'active'),
(3, 'Mesin Pengering', 'Mesin pengering laundry', 4800000, CURDATE(), 'active'),
(3, 'Setrika Uap', 'Setrika uap laundry', 1350000, CURDATE(), 'active'),
(3, 'Meja Lipat', 'Meja lipat pakaian', 950000, CURDATE(), 'active'),
(3, 'Keranjang Laundry', 'Keranjang pakaian', 180000, CURDATE(), 'active'),
(3, 'Rak Gantungan', 'Rak gantungan baju', 1200000, CURDATE(), 'active'),
(3, 'Timbangan Laundry', 'Timbangan pakaian', 420000, CURDATE(), 'active'),
(3, 'Dispenser', 'Dispenser air', 650000, CURDATE(), 'active'),
(3, 'Kursi Tunggu', 'Kursi ruang tunggu', 750000, CURDATE(), 'active'),
(3, 'Vacuum Cleaner', 'Vacuum cleaner industri', 2100000, CURDATE(), 'active'),

-- BUSINESS ID 4
(4, 'Mesin Cetak', 'Mesin cetak offset', 12500000, CURDATE(), 'active'),
(4, 'Komputer Desain', 'PC desain grafis', 9800000, CURDATE(), 'active'),
(4, 'Printer Warna', 'Printer warna A3', 6500000, CURDATE(), 'active'),
(4, 'Meja Kerja', 'Meja kerja karyawan', 1800000, CURDATE(), 'active'),
(4, 'Kursi Kantor', 'Kursi kantor ergonomis', 2200000, CURDATE(), 'active'),
(4, 'Rak Kertas', 'Rak penyimpanan kertas', 950000, CURDATE(), 'active'),
(4, 'Mesin Laminating', 'Mesin laminating dokumen', 3200000, CURDATE(), 'active'),
(4, 'Cutter Besar', 'Mesin potong kertas', 2700000, CURDATE(), 'active'),
(4, 'Scanner', 'Scanner resolusi tinggi', 1850000, CURDATE(), 'active'),
(4, 'UPS', 'UPS komputer', 1250000, CURDATE(), 'active');


-- data dummy items
INSERT INTO items (businessId, itemName, category, purchasePrice, sellingPrice, stockQuantity, movingStatus) VALUES
-- BUSINESS ID 1 (Toko Sembako)
(1, 'Beras Premium 5kg', 'Sembako', 65000, 75000, 120, 'FAST'),
(1, 'Gula Pasir 1kg', 'Sembako', 13500, 15500, 200, 'FAST'),
(1, 'Minyak Goreng 1L', 'Sembako', 14500, 16500, 180, 'FAST'),
(1, 'Tepung Terigu 1kg', 'Sembako', 12000, 14000, 160, 'FAST'),
(1, 'Mie Instan', 'Makanan', 2500, 3500, 500, 'FAST'),
(1, 'Susu Kental Manis', 'Minuman', 9000, 11000, 90, 'SLOW'),
(1, 'Kopi Bubuk 200g', 'Minuman', 18000, 22000, 60, 'SLOW'),
(1, 'Sabun Cuci', 'Kebutuhan Rumah', 7000, 9000, 70, 'SLOW'),
(1, 'Baterai AA', 'Elektronik', 12000, 15000, 40, 'DEAD'),
(1, 'Korek Api', 'Lainnya', 2000, 3000, 150, 'FAST'),

-- BUSINESS ID 2 (Kedai Kopi)
(2, 'Biji Kopi Arabica 250g', 'Bahan Baku', 45000, 65000, 80, 'FAST'),
(2, 'Biji Kopi Robusta 250g', 'Bahan Baku', 38000, 55000, 70, 'FAST'),
(2, 'Susu Fresh 1L', 'Bahan Baku', 18000, 25000, 60, 'FAST'),
(2, 'Gula Cair', 'Bahan Baku', 12000, 18000, 50, 'SLOW'),
(2, 'Cup Kopi Panas', 'Perlengkapan', 800, 1500, 1000, 'FAST'),
(2, 'Cup Kopi Dingin', 'Perlengkapan', 900, 1700, 900, 'FAST'),
(2, 'Sedotan', 'Perlengkapan', 500, 1000, 1500, 'FAST'),
(2, 'Sirup Vanilla', 'Bahan Tambahan', 65000, 85000, 25, 'SLOW'),
(2, 'Sirup Caramel', 'Bahan Tambahan', 65000, 85000, 20, 'SLOW'),
(2, 'Chocolate Powder', 'Bahan Tambahan', 72000, 95000, 15, 'DEAD'),

-- BUSINESS ID 3 (Laundry)
(3, 'Detergen Bubuk 1kg', 'Bahan Laundry', 18000, 25000, 90, 'FAST'),
(3, 'Pewangi Laundry', 'Bahan Laundry', 22000, 30000, 70, 'FAST'),
(3, 'Plastik Laundry', 'Perlengkapan', 5000, 8000, 300, 'FAST'),
(3, 'Hanger Plastik', 'Perlengkapan', 3500, 6000, 200, 'SLOW'),
(3, 'Hanger Besi', 'Perlengkapan', 8500, 12000, 120, 'SLOW'),
(3, 'Label Nama', 'Perlengkapan', 2000, 4000, 250, 'FAST'),
(3, 'Kantong Laundry Besar', 'Perlengkapan', 12000, 18000, 60, 'SLOW'),
(3, 'Sabun Cair', 'Bahan Laundry', 25000, 35000, 40, 'SLOW'),
(3, 'Pembersih Mesin', 'Perawatan', 35000, 50000, 10, 'DEAD'),
(3, 'Sikat Laundry', 'Perlengkapan', 8000, 12000, 25, 'DEAD'),

-- BUSINESS ID 4 (Percetakan)
(4, 'Kertas A4 80gsm', 'Kertas', 45000, 60000, 200, 'FAST'),
(4, 'Kertas A3 100gsm', 'Kertas', 75000, 95000, 150, 'FAST'),
(4, 'Tinta Printer Hitam', 'Tinta', 85000, 110000, 60, 'FAST'),
(4, 'Tinta Printer Warna', 'Tinta', 95000, 125000, 55, 'FAST'),
(4, 'Cover Laminating', 'Finishing', 35000, 55000, 80, 'SLOW'),
(4, 'Spiral Jilid', 'Finishing', 15000, 25000, 120, 'SLOW'),
(4, 'Map Plastik', 'ATK', 2500, 5000, 300, 'FAST'),
(4, 'Kertas Foto', 'Kertas', 95000, 125000, 30, 'SLOW'),
(4, 'Brosur Cetak', 'Produk', 1200, 2500, 500, 'FAST'),
(4, 'Stiker Vinyl', 'Produk', 3500, 7000, 20, 'DEAD');

-- incoming items
INSERT INTO inComingItems (itemsId, businessId, userId, quantity, unitPrice, inComingDate) VALUES
-- ITEM ID 1
(1, 1, 3, 20, 65000, CURRENT_TIMESTAMP),
(1, 1, 3, 15, 64000, CURRENT_TIMESTAMP),
(1, 1, 3, 25, 65500, CURRENT_TIMESTAMP),
(1, 1, 3, 10, 66000, CURRENT_TIMESTAMP),

-- ITEM ID 2
(2, 1, 3, 30, 13500, CURRENT_TIMESTAMP),
(2, 1, 3, 25, 13800, CURRENT_TIMESTAMP),
(2, 1, 3, 20, 14000, CURRENT_TIMESTAMP),
(2, 1, 3, 15, 13700, CURRENT_TIMESTAMP),

-- ITEM ID 3
(3, 1, 3, 40, 14500, CURRENT_TIMESTAMP),
(3, 1, 3, 30, 14800, CURRENT_TIMESTAMP),
(3, 1, 3, 25, 15000, CURRENT_TIMESTAMP),
(3, 1, 3, 20, 14700, CURRENT_TIMESTAMP),

-- ITEM ID 4
(4, 1, 3, 35, 12000, CURRENT_TIMESTAMP),
(4, 1, 3, 30, 12200, CURRENT_TIMESTAMP),
(4, 1, 3, 25, 12500, CURRENT_TIMESTAMP),
(4, 1, 3, 20, 12300, CURRENT_TIMESTAMP),

-- ITEM ID 5
(5, 1, 3, 100, 2500, CURRENT_TIMESTAMP),
(5, 1, 3, 80, 2600, CURRENT_TIMESTAMP),
(5, 1, 3, 120, 2550, CURRENT_TIMESTAMP),
(5, 1, 3, 90, 2580, CURRENT_TIMESTAMP),

-- ITEM ID 6
(6, 1, 3, 25, 9000, CURRENT_TIMESTAMP),
(6, 1, 3, 20, 9200, CURRENT_TIMESTAMP),
(6, 1, 3, 15, 9500, CURRENT_TIMESTAMP),
(6, 1, 3, 10, 9400, CURRENT_TIMESTAMP),

-- ITEM ID 7
(7, 1, 3, 18, 18000, CURRENT_TIMESTAMP),
(7, 1, 3, 15, 18500, CURRENT_TIMESTAMP),
(7, 1, 3, 12, 19000, CURRENT_TIMESTAMP),
(7, 1, 3, 10, 18800, CURRENT_TIMESTAMP),

-- ITEM ID 8
(8, 1, 3, 22, 7000, CURRENT_TIMESTAMP),
(8, 1, 3, 20, 7200, CURRENT_TIMESTAMP),
(8, 1, 3, 18, 7400, CURRENT_TIMESTAMP),
(8, 1, 3, 15, 7300, CURRENT_TIMESTAMP),

-- ITEM ID 9
(9, 1, 3, 12, 12000, CURRENT_TIMESTAMP),
(9, 1, 3, 10, 12500, CURRENT_TIMESTAMP),
(9, 1, 3, 8, 13000, CURRENT_TIMESTAMP),
(9, 1, 3, 6, 12800, CURRENT_TIMESTAMP),

-- ITEM ID 10
(10, 1, 3, 50, 2000, CURRENT_TIMESTAMP),
(10, 1, 3, 45, 2100, CURRENT_TIMESTAMP),
(10, 1, 3, 40, 2200, CURRENT_TIMESTAMP),
(10, 1, 3, 35, 2150, CURRENT_TIMESTAMP),

(11, 2, 7, 50, 44000, CURRENT_TIMESTAMP),
(12, 2, 7, 50, 37000, CURRENT_TIMESTAMP),
(13, 2, 7, 40, 17500, CURRENT_TIMESTAMP),

(14, 2, 7, 30, 11500, CURRENT_TIMESTAMP),
(18, 2, 7, 20, 64000, CURRENT_TIMESTAMP),
(19, 2, 7, 15, 64000, CURRENT_TIMESTAMP),

(15, 2, 7, 500, 750, CURRENT_TIMESTAMP),
(16, 2, 7, 400, 850, CURRENT_TIMESTAMP),
(17, 2, 7, 600, 480, CURRENT_TIMESTAMP),

(20, 2, 7, 10, 70000, CURRENT_TIMESTAMP);

-- data dummy outComing Items
INSERT INTO outComingItems (itemsId, businessId, userId, quantity, unitPrice, outComingDate) VALUES
-- ITEM ID 1
(1, 1, 4, 5, 75000, CURRENT_TIMESTAMP),
(1, 1, 4, 8, 75000, CURRENT_TIMESTAMP),
(1, 1, 4, 6, 76000, CURRENT_TIMESTAMP),
(1, 1, 4, 4, 75000, CURRENT_TIMESTAMP),

-- ITEM ID 2
(2, 1, 4, 10, 15500, CURRENT_TIMESTAMP),
(2, 1, 4, 12, 15500, CURRENT_TIMESTAMP),
(2, 1, 4, 8, 16000, CURRENT_TIMESTAMP),
(2, 1, 4, 6, 15500, CURRENT_TIMESTAMP),

-- ITEM ID 3
(3, 1, 4, 15, 16500, CURRENT_TIMESTAMP),
(3, 1, 4, 12, 16500, CURRENT_TIMESTAMP),
(3, 1, 4, 10, 17000, CURRENT_TIMESTAMP),
(3, 1, 4, 8, 16500, CURRENT_TIMESTAMP),

-- ITEM ID 4
(4, 1, 4, 12, 14000, CURRENT_TIMESTAMP),
(4, 1, 4, 10, 14000, CURRENT_TIMESTAMP),
(4, 1, 4, 8, 14500, CURRENT_TIMESTAMP),
(4, 1, 4, 6, 14000, CURRENT_TIMESTAMP),

-- ITEM ID 5
(5, 1, 4, 40, 3500, CURRENT_TIMESTAMP),
(5, 1, 4, 35, 3500, CURRENT_TIMESTAMP),
(5, 1, 4, 50, 3600, CURRENT_TIMESTAMP),
(5, 1, 4, 30, 3500, CURRENT_TIMESTAMP),

-- ITEM ID 6
(6, 1, 4, 6, 11000, CURRENT_TIMESTAMP),
(6, 1, 4, 8, 11000, CURRENT_TIMESTAMP),
(6, 1, 4, 5, 11500, CURRENT_TIMESTAMP),
(6, 1, 4, 4, 11000, CURRENT_TIMESTAMP),

-- ITEM ID 7
(7, 1, 4, 5, 22000, CURRENT_TIMESTAMP),
(7, 1, 4, 6, 22000, CURRENT_TIMESTAMP),
(7, 1, 4, 4, 22500, CURRENT_TIMESTAMP),
(7, 1, 4, 3, 22000, CURRENT_TIMESTAMP),

-- ITEM ID 8
(8, 1, 4, 10, 9000, CURRENT_TIMESTAMP),
(8, 1, 4, 12, 9000, CURRENT_TIMESTAMP),
(8, 1, 4, 8, 9500, CURRENT_TIMESTAMP),
(8, 1, 4, 6, 9000, CURRENT_TIMESTAMP),

-- ITEM ID 9
(9, 1, 4, 3, 15000, CURRENT_TIMESTAMP),
(9, 1, 4, 4, 15000, CURRENT_TIMESTAMP),
(9, 1, 4, 2, 15500, CURRENT_TIMESTAMP),
(9, 1, 4, 1, 15000, CURRENT_TIMESTAMP),

-- ITEM ID 10
(10, 1, 4, 20, 3000, CURRENT_TIMESTAMP),
(10, 1, 4, 18, 3000, CURRENT_TIMESTAMP),
(10, 1, 4, 15, 3200, CURRENT_TIMESTAMP),
(10, 1, 4, 12, 3000, CURRENT_TIMESTAMP),

(11, 2, 8, 30, 67000, CURRENT_TIMESTAMP),
(12, 2, 8, 35, 56000, CURRENT_TIMESTAMP),
(13, 2, 8, 25, 26000, CURRENT_TIMESTAMP),

(15, 2, 8, 300, 1600, CURRENT_TIMESTAMP),
(16, 2, 8, 250, 1800, CURRENT_TIMESTAMP),
(17, 2, 8, 400, 1100, CURRENT_TIMESTAMP),

(14, 2, 8, 10, 19000, CURRENT_TIMESTAMP),
(18, 2, 8, 8, 88000, CURRENT_TIMESTAMP),
(19, 2, 8, 6, 88000, CURRENT_TIMESTAMP),

(20, 2, 8, 5, 98000, CURRENT_TIMESTAMP);


INSERT INTO employeePresence (userID, presenceDate, clockIN, clockOUT) VALUES
(1, '2025-01-01', '08:00:00', '17:00:00'),
(2, '2025-01-01', '08:05:00', '17:02:00'),
(3, '2025-01-01', '07:58:00', '16:55:00'),
(4, '2025-01-01', '08:10:00', '17:15:00'),
(5, '2025-01-01', '08:02:00', '17:00:00'),

(6, '2025-01-02', '08:00:00', '17:00:00'),
(7, '2025-01-02', '08:07:00', '17:10:00'),
(8, '2025-01-02', '07:55:00', '16:50:00'),
(9, '2025-01-02', '08:12:00', '17:20:00'),
(10,'2025-01-02', '08:01:00', '17:00:00'),

(1, '2025-01-03', '08:03:00', '17:05:00'),
(2, '2025-01-03', '08:00:00', '17:00:00'),
(3, '2025-01-03', '08:06:00', '17:10:00'),
(4, '2025-01-03', '08:15:00', '17:25:00'),
(5, '2025-01-03', '07:59:00', '16:58:00'),

(6, '2025-01-04', '08:02:00', '17:00:00'),
(7, '2025-01-04', '08:00:00', '17:00:00'),
(8, '2025-01-04', '08:05:00', '17:10:00'),
(9, '2025-01-04', '08:08:00', '17:12:00'),
(10,'2025-01-04', '07:57:00', '16:55:00'),

(1, '2025-01-05', '08:00:00', '17:00:00'),
(2, '2025-01-05', '08:04:00', '17:05:00'),
(3, '2025-01-05', '08:10:00', '17:15:00'),
(4, '2025-01-05', '08:20:00', '17:30:00'),
(5, '2025-01-05', '07:56:00', '16:50:00'),

(6, '2025-01-06', '08:01:00', '17:00:00'),
(7, '2025-01-06', '08:03:00', '17:05:00'),
(8, '2025-01-06', '08:00:00', '17:00:00'),
(9, '2025-01-06', '08:09:00', '17:18:00'),
(10,'2025-01-06', '08:02:00', '17:05:00'),