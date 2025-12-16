-- create table inventaries
CREATE TABLE inventaries (
    invId INT AUTO_INCREMENT PRIMARY KEY,
    businessId INT,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(200) NOT NULL,
    price INT NOT NULL, 
    purchaseDate DATE NOT NULL,
    status ENUM('active','inactive') NOT NULL DEFAULT 'active'
);

-- insert 40 data dummy 
INSERT INTO inventaries (businessId, name, description, price, purchaseDate, status) VALUES
(1, 'Etalase Kaca', 'Etalase untuk display produk', 2500000, '2023-01-10', 'active'),
(1, 'Meja Kasir', 'Meja kasir kayu', 1200000, '2023-01-12', 'active'),
(1, 'Kursi Kasir', 'Kursi kasir plastik', 250000, '2023-01-12', 'active'),
(1, 'Rak Besi', 'Rak besi penyimpanan barang', 1800000, '2023-01-15', 'active'),
(1, 'Timbangan Digital', 'Timbangan digital 30kg', 650000, '2023-01-18', 'active'),
(1, 'Printer Struk', 'Printer thermal struk', 900000, '2023-01-20', 'active'),
(1, 'Mesin Kasir', 'Mesin kasir elektronik', 3500000, '2023-01-22', 'active'),
(1, 'Lemari Penyimpanan', 'Lemari kayu penyimpanan', 2200000, '2023-01-25', 'active'),
(1, 'Kipas Angin', 'Kipas angin berdiri', 450000, '2023-01-27', 'active'),
(1, 'Lampu LED', 'Lampu LED toko', 150000, '2023-01-28', 'active'),

(1, 'AC Toko', 'AC 1 PK', 4200000, '2023-02-01', 'active'),
(1, 'CCTV Indoor', 'Kamera CCTV dalam ruangan', 800000, '2023-02-03', 'active'),
(1, 'CCTV Outdoor', 'Kamera CCTV luar ruangan', 950000, '2023-02-03', 'active'),
(1, 'Router WiFi', 'Router internet toko', 650000, '2023-02-05', 'active'),
(1, 'Komputer Kasir', 'PC kasir utama', 5500000, '2023-02-07', 'active'),
(1, 'Monitor Kasir', 'Monitor LED 22 inch', 1800000, '2023-02-07', 'active'),
(1, 'Keyboard Kasir', 'Keyboard USB', 150000, '2023-02-07', 'active'),
(1, 'Mouse Kasir', 'Mouse USB', 120000, '2023-02-07', 'active'),
(1, 'UPS', 'UPS untuk komputer kasir', 900000, '2023-02-10', 'active'),
(1, 'Brankas', 'Brankas penyimpanan uang', 3000000, '2023-02-12', 'active'),

(1, 'Rak Display Minuman', 'Rak pendingin minuman', 6500000, '2023-02-15', 'active'),
(1, 'Freezer', 'Freezer penyimpanan es', 7200000, '2023-02-18', 'active'),
(1, 'Meja Kerja', 'Meja kerja staff', 950000, '2023-02-20', 'active'),
(1, 'Kursi Staff', 'Kursi kerja staff', 550000, '2023-02-20', 'active'),
(1, 'Dispenser Air', 'Dispenser air minum', 450000, '2023-02-22', 'active'),
(1, 'Microwave', 'Microwave untuk kebutuhan staff', 1200000, '2023-02-25', 'active'),
(1, 'Rak Arsip', 'Rak arsip dokumen', 850000, '2023-02-27', 'inactive'),
(1, 'Telepon Kantor', 'Telepon kabel kantor', 300000, '2023-03-01', 'inactive'),
(1, 'Speaker Toko', 'Speaker audio toko', 750000, '2023-03-03', 'active'),
(1, 'Jam Dinding', 'Jam dinding toko', 120000, '2023-03-05', 'active'),

(1, 'Papan Nama', 'Papan nama toko', 1800000, '2023-03-07', 'active'),
(1, 'Mesin EDC', 'Mesin pembayaran kartu', 0, '2023-03-08', 'active'),
(1, 'Rak Gudang', 'Rak gudang belakang', 2600000, '2023-03-10', 'active'),
(1, 'Troli Barang', 'Troli angkut barang', 850000, '2023-03-12', 'active'),
(1, 'Tangga Lipat', 'Tangga lipat aluminium', 650000, '2023-03-15', 'active'),
(1, 'Vacuum Cleaner', 'Alat pembersih toko', 950000, '2023-03-18', 'inactive'),
(1, 'Kotak P3K', 'Perlengkapan P3K', 250000, '2023-03-20', 'active'),
(1, 'APAR', 'Alat pemadam api ringan', 600000, '2023-03-22', 'active'),
(1, 'Banner Promosi', 'Banner promosi toko', 350000, '2023-03-25', 'inactive');
