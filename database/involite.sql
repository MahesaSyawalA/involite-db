-- create new database
CREATE DATABASE IF NOT EXISTS involite_db;
USE involite_db;


-- CREATE ALL TABLE 
-- create table business
CREATE TABLE business (
    businessId INT AUTO_INCREMENT PRIMARY KEY,
    businessName VARCHAR(150) NOT NULL,
    ownerName VARCHAR(100) NOT NULL,
    businessType VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    phoneNumber VARCHAR(20) NOT NULL
);

-- insert data business
INSERT INTO business (businessName, ownerName, businessType, address, phoneNumber) VALUES
('UMKM Jaya Abadi', 'Andi Pratama', 'Retail', 'Jakarta Selatan', '08123000001'),
('Sumber Makmur', 'Budi Santoso', 'Wholesale', 'Bandung', '08123000002'),
('Maju Bersama', 'Citra Lestari', 'Food & Beverage', 'Surabaya', '08123000003'),
('Toko Sejahtera', 'Dewi Anggraini', 'Retail', 'Yogyakarta', '08123000004'),
('CV Nusantara', 'Eko Saputra', 'Manufacture', 'Semarang', '08123000005'),
('Warung Berkah', 'Fajar Hidayat', 'Food & Beverage', 'Solo', '08123000006'),
('Karya Mandiri', 'Gilang Ramadhan', 'Service', 'Malang', '08123000007'),
('Sentosa Jaya', 'Hendra Wijaya', 'Retail', 'Medan', '08123000008'),
('Makmur Abadi', 'Intan Permata', 'Wholesale', 'Padang', '08123000009'),
('Toko Kita', 'Joko Susilo', 'Retail', 'Bekasi', '08123000010'),
('UMKM Sejahtera', 'Kurniawan', 'Retail', 'Depok', '08123000011'),
('Dapoer Ibu', 'Lina Marlina', 'Food & Beverage', 'Bogor', '08123000012'),
('Fresh Mart', 'Miko Wijaya', 'Retail', 'Tangerang', '08123000013'),
('Berkah Jaya', 'Nanda Putra', 'Service', 'Cirebon', '08123000014'),
('Kedai Kopi Kita', 'Oki Prasetyo', 'Food & Beverage', 'Purwokerto', '08123000015'),
('Tani Makmur', 'Putra Adi', 'Agribusiness', 'Klaten', '08123000016'),
('Toko Bangunan Maju', 'Rizky Ramadhan', 'Retail', 'Sukabumi', '08123000017'),
('Sari Rasa', 'Santi Dewi', 'Food & Beverage', 'Tasikmalaya', '08123000018'),
('Elektronik Jaya', 'Taufik Hidayat', 'Retail', 'Karawang', '08123000019'),
('Mega Grosir', 'Umar Faruq', 'Wholesale', 'Cikarang', '08123000020'),
('Bintang Usaha', 'Agus Salim', 'Retail', 'Jakarta Timur', '08123000021'),
('Rasa Nusantara', 'Ayu Puspita', 'Food & Beverage', 'Jakarta Barat', '08123000022'),
('Prima Jaya', 'Bagus Prakoso', 'Service', 'Serang', '08123000023'),
('Grosir Murah', 'Bayu Setiawan', 'Wholesale', 'Tegal', '08123000024'),
('Dapur Selera', 'Bella Kartika', 'Food & Beverage', 'Magelang', '08123000025'),
('Cahaya Teknik', 'Dani Kurnia', 'Service', 'Cilacap', '08123000026'),
('Sukses Mandiri', 'Dedi Firmansyah', 'Retail', 'Kudus', '08123000027'),
('Lestari Tani', 'Desi Rahmawati', 'Agribusiness', 'Boyolali', '08123000028'),
('Sinar Abadi', 'Dimas Saputra', 'Manufacture', 'Salatiga', '08123000029'),
('Aneka Rasa', 'Dina Oktaviani', 'Food & Beverage', 'Pekalongan', '08123000030'),
('Mitra Sejahtera', 'Eka Prabowo', 'Service', 'Brebes', '08123000031'),
('Toko Harapan', 'Eli Susanti', 'Retail', 'Pemalang', '08123000032'),
('Bumi Makmur', 'Fahmi Akbar', 'Agribusiness', 'Ngawi', '08123000033'),
('Kedai Senja', 'Farah Nabila', 'Food & Beverage', 'Madiun', '08123000034'),
('Indah Elektrik', 'Fauzan Ali', 'Retail', 'Kediri', '08123000035'),
('Jaya Konstruksi', 'Firmansyah', 'Service', 'Blitar', '08123000036'),
('Sari Tani', 'Fitri Handayani', 'Agribusiness', 'Tuban', '08123000037'),
('Makmur Sentosa', 'Galih Pratama', 'Wholesale', 'Lamongan', '08123000038'),
('Warung Kita', 'Gita Amalia', 'Food & Beverage', 'Banyuwangi', '08123000039'),
('Sentral Grosir', 'Hafiz Rahman', 'Wholesale', 'Jember', '08123000040'),
('Cipta Usaha', 'Hana Lestari', 'Service', 'Probolinggo', '08123000041'),
('Toko Maju Jaya', 'Hariyanto', 'Retail', 'Pasuruan', '08123000042'),
('Roti Bahagia', 'Intan Sari', 'Food & Beverage', 'Sidoarjo', '08123000043'),
('Tani Sejahtera', 'Irwan Maulana', 'Agribusiness', 'Nganjuk', '08123000044'),
('Mega Teknik', 'Jefri Kurniawan', 'Service', 'Gresik', '08123000045'),
('Dunia Plastik', 'Kamaludin', 'Manufacture', 'Mojokerto', '08123000046'),
('Toko Keluarga', 'Kartika Dewi', 'Retail', 'Lumajang', '08123000047'),
('Sumber Rejeki', 'Lukman Hakim', 'Wholesale', 'Situbondo', '08123000048'),
('Kopi Pagi', 'Maya Salsabila', 'Food & Beverage', 'Bondowoso', '08123000049'),
('Usaha Baru', 'Muhammad Rizal', 'Service', 'Ponorogo', '08123000050'),
('Toko Andalan', 'Niko Prasetyo', 'Retail', 'Pacitan', '08123000051'),
('Panen Raya', 'Nurhadi', 'Agribusiness', 'Magetan', '08123000052'),
('Selera Kampung', 'Nurlaila', 'Food & Beverage', 'Trenggalek', '08123000053'),
('Prima Grosir', 'Omar Syah', 'Wholesale', 'Tulungagung', '08123000054'),
('Sinar Jaya', 'Putri Azzahra', 'Retail', 'Batu', '08123000055'),
('Tekno Service', 'Rafi Alamsyah', 'Service', 'Malang', '08123000056'),
('Dapoer Nusantara', 'Ratna Wulandari', 'Food & Beverage', 'Surabaya', '08123000057'),
('Sumber Tani', 'Rendi Saputra', 'Agribusiness', 'Bojonegoro', '08123000058'),
('Mitra Teknik', 'Said Abdullah', 'Service', 'Tuban', '08123000059'),
('Grosir Sejahtera', 'Yusuf Ramadhan', 'Wholesale', 'Lamongan', '08123000060'),
('UMKM Muda', 'Zaki Firmansyah', 'Retail', 'Gresik', '08123000061'),
('Kedai Rindu', 'Zahra Putri', 'Food & Beverage', 'Sidoarjo', '08123000062'),
('Cahaya Usaha', 'Arman Hidayat', 'Service', 'Jakarta Pusat', '08123000063'),
('Toko Nusantara', 'Sri Wahyuni', 'Retail', 'Jakarta Utara', '08123000064'),
('Sari Laut Kita', 'Wawan Setiawan', 'Food & Beverage', 'Jakarta Selatan', '08123000065'),
('Agro Mandiri', 'Bambang Sudrajat', 'Agribusiness', 'Indramayu', '08123000066'),
('Berkah Teknik', 'Ilham Prakoso', 'Service', 'Subang', '08123000067'),
('Mega Retail', 'Siti Aminah', 'Retail', 'Purwakarta', '08123000068'),
('Rasa Bahari', 'Teguh Santoso', 'Food & Beverage', 'Pati', '08123000069'),
('Sukses Bersama', 'Yuni Kartika', 'Wholesale', 'Jepara', '08123000070');

-- create table users
CREATE TABLE users (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    businessId INT NOT NULL,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100),
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    role ENUM('owner','akuntan','gudang','sales') NOT NULL,

    CONSTRAINT fk_users_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- insert data dummy users
INSERT INTO users (businessId, firstName, lastName, email, phone, role) VALUES
-- BUSINESS 1
(1, 'Andi', 'Saputra', 'andi1@usaha.com', '081200000001', 'owner'),
(1, 'Rina', 'Kurniawati', 'rina1@usaha.com', '081200000002', 'akuntan'),
(1, 'Budi', 'Santoso', 'budi1@usaha.com', '081200000003', 'gudang'),
(1, 'Siti', 'Aisyah', 'siti1@usaha.com', '081200000004', 'sales'),
(1, 'Deni', 'Pratama', 'deni1@usaha.com', '081200000005', 'sales'),
(1, 'Lina', 'Maharani', 'lina1@usaha.com', '081200000006', 'gudang'),
(1, 'Rudi', 'Hartono', 'rudi1@usaha.com', '081200000007', 'sales'),
(1, 'Maya', 'Putri', 'maya1@usaha.com', '081200000008', 'sales'),

-- BUSINESS 2
(2, 'Ahmad', 'Fauzi', 'ahmad2@usaha.com', '081200000009', 'owner'),
(2, 'Dewi', 'Anggraini', 'dewi2@usaha.com', '081200000010', 'akuntan'),
(2, 'Rizky', 'Ramadhan', 'rizky2@usaha.com', '081200000011', 'sales'),
(2, 'Nina', 'Permata', 'nina2@usaha.com', '081200000012', 'sales'),
(2, 'Fajar', 'Hidayat', 'fajar2@usaha.com', '081200000013', 'gudang'),
(2, 'Putri', 'Lestari', 'putri2@usaha.com', '081200000014', 'gudang'),
(2, 'Agus', 'Salim', 'agus2@usaha.com', '081200000015', 'sales'),
(2, 'Wulan', 'Sari', 'wulan2@usaha.com', '081200000016', 'sales'),

-- BUSINESS 3
(3, 'Bayu', 'Wicaksono', 'bayu3@usaha.com', '081200000017', 'owner'),
(3, 'Intan', 'Sari', 'intan3@usaha.com', '081200000018', 'akuntan'),
(3, 'Yoga', 'Prakoso', 'yoga3@usaha.com', '081200000019', 'gudang'),
(3, 'Novi', 'Amelia', 'novi3@usaha.com', '081200000020', 'sales'),
(3, 'Arif', 'Maulana', 'arif3@usaha.com', '081200000021', 'sales'),
(3, 'Tika', 'Rahmawati', 'tika3@usaha.com', '081200000022', 'gudang'),
(3, 'Hendra', 'Gunawan', 'hendra3@usaha.com', '081200000023', 'sales'),
(3, 'Yuni', 'Lestari', 'yuni3@usaha.com', '081200000024', 'sales'),

-- BUSINESS 4
(4, 'Rangga', 'Wijaya', 'rangga4@usaha.com', '081200000025', 'owner'),
(4, 'Salsa', 'Nabila', 'salsa4@usaha.com', '081200000026', 'akuntan'),
(4, 'Ilham', 'Sapriadi', 'ilham4@usaha.com', '081200000027', 'gudang'),
(4, 'Farah', 'Anindya', 'farah4@usaha.com', '081200000028', 'sales'),
(4, 'Iqbal', 'Ramli', 'iqbal4@usaha.com', '081200000029', 'sales'),
(4, 'Dina', 'Oktaviani', 'dina4@usaha.com', '081200000030', 'gudang'),
(4, 'Bagus', 'Setiawan', 'bagus4@usaha.com', '081200000031', 'sales'),
(4, 'Citra', 'Ayuningtyas', 'citra4@usaha.com', '081200000032', 'sales'),

-- BUSINESS 5
(5, 'Surya', 'Aditya', 'surya5@usaha.com', '081200000033', 'owner'),
(5, 'Melati', 'Puspitasari', 'melati5@usaha.com', '081200000034', 'akuntan'),
(5, 'Kevin', 'Pranata', 'kevin5@usaha.com', '081200000035', 'sales'),
(5, 'Aulia', 'Rahman', 'aulia5@usaha.com', '081200000036', 'sales'),
(5, 'Rama', 'Kusuma', 'rama5@usaha.com', '081200000037', 'gudang'),
(5, 'Nadya', 'Safitri', 'nadya5@usaha.com', '081200000038', 'gudang'),
(5, 'Fikri', 'Alamsyah', 'fikri5@usaha.com', '081200000039', 'sales'),
(5, 'Sarah', 'Halim', 'sarah5@usaha.com', '081200000040', 'sales');

-- create table employee presence
CREATE TABLE employeePresence (
    presenceId INT PRIMARY KEY AUTO_INCREMENT,
    userId INT NOT NULL,
    presenceDate DATE NOT NULL,
    clockIN TIME NOT NULL,
    clockOUT TIME,

    CONSTRAINT fk_employeePresence_user
        FOREIGN KEY (userId)
        REFERENCES users(userId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    UNIQUE (userId, presenceDate),
    CHECK (clockOUT IS NULL OR clockOUT > clockIN)
);

-- insert data dummy employee presence
INSERT INTO employeePresence (userId, presenceDate, clockIN, clockOUT) VALUES
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

(1, '2025-01-07', '08:00:00', NULL),
(2, '2025-01-07', '08:05:00', NULL),
(3, '2025-01-07', '07:59:00', NULL),
(4, '2025-01-07', '08:12:00', NULL),
(5, '2025-01-07', '08:03:00', NULL),

(6, '2025-01-07', '08:00:00', NULL),
(7, '2025-01-07', '08:06:00', NULL),
(8, '2025-01-07', '08:02:00', NULL),
(9, '2025-01-07', '08:10:00', NULL),
(10,'2025-01-07', '07:58:00', NULL);

-- create table inventaries
CREATE TABLE inventaries (
    invId INT AUTO_INCREMENT PRIMARY KEY,
    businessId INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(200) NOT NULL,
    price DECIMAL(15,2) DEFAULT 0, 
    purchaseDate DATE NOT NULL,
    status ENUM('active','inactive') NOT NULL DEFAULT 'active',

    CONSTRAINT fk_inventaries_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- insert data dummy inventaries
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

-- create table items
CREATE TABLE items (
    itemsId INT AUTO_INCREMENT PRIMARY KEY,
    businessId INT NOT NULL, 
    itemName VARCHAR(150) NOT NULL, 
    category VARCHAR(100) NOT NULL, 
    purchasePrice DECIMAL(12,2) DEFAULT 0, 
    sellingPrice DECIMAL(12,2) DEFAULT 0, 
    stockQuantity INT NOT NULL, 
    movingStatus ENUM('FAST','SLOW','DEAD') NOT NULL,

    CONSTRAINT fk_items_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT 
);

-- insert data dummy items
INSERT INTO items 
(businessId, itemName, category, purchasePrice, sellingPrice, stockQuantity, movingStatus) 
VALUES
-- BUSINESS 1
(1, 'Beras Premium 5kg', 'Sembako', 65000.00, 72000.00, 50, 'FAST'),
(1, 'Minyak Goreng 1L', 'Sembako', 14500.00, 16000.00, 120, 'FAST'),
(1, 'Gula Pasir 1kg', 'Sembako', 13500.00, 15000.00, 80, 'FAST'),
(1, 'Tepung Terigu 1kg', 'Sembako', 9500.00, 11000.00, 60, 'SLOW'),
(1, 'Kopi Bubuk 200gr', 'Minuman', 18000.00, 22000.00, 40, 'SLOW'),
(1, 'Teh Celup', 'Minuman', 9000.00, 12000.00, 70, 'SLOW'),
(1, 'Susu UHT 1L', 'Minuman', 16000.00, 18500.00, 90, 'FAST'),
(1, 'Mi Instan', 'Makanan', 2800.00, 3500.00, 300, 'FAST'),
(1, 'Biskuit Coklat', 'Snack', 7000.00, 9000.00, 55, 'SLOW'),
(1, 'Air Mineral 600ml', 'Minuman', 3000.00, 4000.00, 200, 'FAST'),

-- BUSINESS 2
(2, 'Pulpen Gel', 'ATK', 2500.00, 4000.00, 150, 'FAST'),
(2, 'Buku Tulis', 'ATK', 4500.00, 6500.00, 120, 'FAST'),
(2, 'Pensil 2B', 'ATK', 1500.00, 3000.00, 200, 'FAST'),
(2, 'Penghapus', 'ATK', 800.00, 2000.00, 180, 'SLOW'),
(2, 'Spidol Whiteboard', 'ATK', 7000.00, 9500.00, 60, 'SLOW'),
(2, 'Kertas A4', 'ATK', 38000.00, 45000.00, 40, 'FAST'),
(2, 'Map Plastik', 'ATK', 2000.00, 3500.00, 90, 'SLOW'),
(2, 'Stabilo', 'ATK', 5000.00, 7500.00, 75, 'SLOW'),
(2, 'Amplop Coklat', 'ATK', 1200.00, 2500.00, 110, 'SLOW'),
(2, 'Penggaris 30cm', 'ATK', 3000.00, 5000.00, 85, 'DEAD'),

-- BUSINESS 3
(3, 'Kaos Polos', 'Fashion', 45000.00, 75000.00, 70, 'FAST'),
(3, 'Kemeja Pria', 'Fashion', 95000.00, 145000.00, 40, 'FAST'),
(3, 'Celana Jeans', 'Fashion', 125000.00, 195000.00, 30, 'SLOW'),
(3, 'Jaket Hoodie', 'Fashion', 110000.00, 175000.00, 25, 'SLOW'),
(3, 'Topi Baseball', 'Fashion', 35000.00, 55000.00, 60, 'SLOW'),
(3, 'Sandal Jepit', 'Fashion', 18000.00, 30000.00, 90, 'FAST'),
(3, 'Sepatu Sneakers', 'Fashion', 250000.00, 350000.00, 20, 'FAST'),
(3, 'Ikat Pinggang', 'Fashion', 40000.00, 65000.00, 35, 'DEAD'),
(3, 'Dompet Pria', 'Fashion', 60000.00, 95000.00, 28, 'SLOW'),
(3, 'Kaos Kaki', 'Fashion', 8000.00, 15000.00, 100, 'FAST'),

-- BUSINESS 4
(4, 'Sabun Cair', 'Kebersihan', 9000.00, 12000.00, 85, 'FAST'),
(4, 'Shampoo 170ml', 'Kebersihan', 12000.00, 16000.00, 70, 'FAST'),
(4, 'Pasta Gigi', 'Kebersihan', 9500.00, 13000.00, 65, 'SLOW'),
(4, 'Deterjen Bubuk', 'Kebersihan', 18000.00, 23000.00, 50, 'FAST'),
(4, 'Pewangi Pakaian', 'Kebersihan', 15000.00, 20000.00, 40, 'SLOW'),
(4, 'Tisu Gulung', 'Kebersihan', 8500.00, 12000.00, 75, 'FAST'),
(4, 'Pembersih Lantai', 'Kebersihan', 13000.00, 17000.00, 45, 'SLOW'),
(4, 'Sabun Cuci Piring', 'Kebersihan', 11000.00, 15000.00, 60, 'FAST'),
(4, 'Masker Medis', 'Kesehatan', 1500.00, 3000.00, 200, 'DEAD'),
(4, 'Hand Sanitizer', 'Kesehatan', 9000.00, 15000.00, 55, 'SLOW');


-- create table incoming (restock / purchase)
CREATE TABLE inComingItems (
    iciId INT AUTO_INCREMENT PRIMARY KEY,

    itemsId INT NOT NULL,
    businessId INT NOT NULL,
    userId INT NOT NULL,

    quantity INT NOT NULL,
    unitPrice DECIMAL(15,2) DEFAULT 0,

    totalPurchase DECIMAL(15,2) GENERATED ALWAYS AS (quantity * unitPrice) STORED,

    inComingDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- relasi
    CONSTRAINT fk_ici_items
        FOREIGN KEY (itemsId)
        REFERENCES items(itemsId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_ici_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_ici_user
        FOREIGN KEY (userId)
        REFERENCES users(userId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- insert data inComingItems 
INSERT INTO inComingItems (itemsId, businessId, userId, quantity, unitPrice, inComingDate) VALUES
(1, 1, 1, 10, 8000,  '2024-12-25 09:00:00'),
(2, 1, 2, 15, 12000, '2024-12-25 10:00:00'),
(3, 1, 3, 20, 5000,  '2024-12-26 11:00:00'),
(4, 2, 1, 12, 9000,  '2024-12-26 13:00:00'),
(5, 2, 2, 18, 6000,  '2024-12-27 14:00:00'),
(6, 2, 3, 8,  15000, '2024-12-27 15:00:00'),
(7, 3, 4, 25, 5500,  '2024-12-28 09:30:00'),
(8, 3, 5, 5,  22000, '2024-12-28 10:30:00'),
(9, 1, 1, 30, 4000,  '2024-12-29 11:00:00'),
(10,1, 2, 10, 20000, '2024-12-29 13:00:00'),

(1, 2, 3, 14, 8000,  '2024-12-30 09:00:00'),
(2, 2, 4, 18, 12000, '2024-12-30 10:30:00'),
(3, 3, 5, 22, 5000,  '2024-12-31 11:00:00'),
(4, 3, 1, 16, 9000,  '2024-12-31 13:00:00'),
(5, 1, 2, 20, 6000,  '2025-01-01 09:00:00'),
(6, 1, 3, 12, 15000, '2025-01-01 10:30:00'),
(7, 2, 4, 28, 5500,  '2025-01-02 11:00:00'),
(8, 2, 5, 6,  22000, '2025-01-02 13:00:00'),
(9, 3, 1, 35, 4000,  '2025-01-03 14:00:00'),
(10,3, 2, 14, 20000, '2025-01-03 15:00:00'),

(1, 1, 3, 18, 8000,  '2025-01-01 09:00:00'),
(2, 1, 4, 22, 12000, '2025-01-01 10:00:00'),
(3, 1, 5, 26, 5000,  '2025-01-01 11:00:00'),
(4, 2, 1, 14, 9000,  '2025-01-05 13:00:00'),
(5, 2, 2, 24, 6000,  '2025-01-06 09:00:00'),
(6, 2, 3, 10, 15000, '2025-01-06 10:30:00'),
(7, 3, 4, 32, 5500,  '2025-01-07 11:00:00'),
(8, 3, 5, 8,  22000, '2025-01-07 13:00:00'),
(9, 1, 1, 40, 4000,  '2025-01-08 14:00:00'),
(10,1, 2, 16, 20000, '2025-01-08 15:00:00'),

(1, 2, 3, 12, 8000,  '2025-01-09 09:00:00'),
(2, 2, 4, 18, 12000, '2025-01-09 10:00:00'),
(3, 3, 5, 20, 5000,  '2025-01-10 11:00:00'),
(4, 3, 1, 15, 9000,  '2025-01-10 13:00:00'),
(5, 1, 2, 22, 6000,  '2025-01-11 09:00:00'),
(6, 1, 3, 11, 15000, '2025-01-11 10:30:00'),
(7, 2, 4, 30, 5500,  '2025-01-12 11:00:00'),
(8, 2, 5, 7,  22000, '2025-01-12 13:00:00'),
(9, 3, 1, 36, 4000,  '2025-01-13 14:00:00'),
(10,3, 2, 15, 20000, '2025-01-13 15:00:00');

-- create table outComingItems atau penjualan
CREATE TABLE outComingItems (
    ociId INT AUTO_INCREMENT PRIMARY KEY,

    itemsId INT NOT NULL,
    businessId INT NOT NULL,
    userId INT NOT NULL,

    quantity INT NOT NULL,
    unitPrice DECIMAL(15,2) DEFAULT 0,

    totalSale DECIMAL(15,2) GENERATED ALWAYS AS (quantity * unitPrice) STORED,

    outComingDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- relasi 
    CONSTRAINT fk_oci_items
        FOREIGN KEY (itemsId)
        REFERENCES items(itemsId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_oci_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_oci_user
        FOREIGN KEY (userId)
        REFERENCES users(userId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- insert data dummy outComingItems
INSERT INTO outComingItems (itemsId, businessId, userId, quantity, unitPrice, outComingDate) VALUES
(1, 1, 1, 2, 10000, '2025-01-01 10:00:00'),
(2, 1, 2, 1, 15000, '2025-01-01 11:00:00'),
(3, 1, 3, 5, 7000,  '2025-01-02 09:30:00'),
(4, 2, 1, 3, 12000, '2025-01-02 13:00:00'),
(5, 2, 2, 4, 9000,  '2025-01-03 14:00:00'),
(6, 2, 3, 2, 20000, '2025-01-03 15:30:00'),
(7, 3, 4, 6, 8000,  '2025-01-04 10:45:00'),
(8, 3, 5, 1, 30000, '2025-01-04 11:15:00'),
(9, 1, 1, 7, 5000,  '2025-01-05 09:00:00'),
(10,1, 2, 2, 25000, '2025-01-05 16:00:00'),

(1, 2, 3, 4, 10000, '2025-01-06 10:00:00'),
(2, 2, 4, 3, 15000, '2025-01-06 11:30:00'),
(3, 3, 5, 6, 7000,  '2025-01-07 12:00:00'),
(4, 3, 1, 1, 12000, '2025-01-07 14:00:00'),
(5, 1, 2, 5, 9000,  '2025-01-08 15:00:00'),
(6, 1, 3, 2, 20000, '2025-01-08 16:00:00'),
(7, 2, 4, 3, 8000,  '2025-01-09 09:00:00'),
(8, 2, 5, 1, 30000, '2025-01-09 10:00:00'),
(9, 3, 1, 8, 5000,  '2025-01-10 11:00:00'),
(10,3, 2, 2, 25000, '2025-01-10 13:00:00'),

(1, 1, 3, 6, 10000, '2025-01-11 10:00:00'),
(2, 1, 4, 4, 15000, '2025-01-11 11:30:00'),
(3, 1, 5, 3, 7000,  '2025-01-12 09:30:00'),
(4, 2, 1, 2, 12000, '2025-01-12 14:00:00'),
(5, 2, 2, 7, 9000,  '2025-01-13 15:00:00'),
(6, 2, 3, 1, 20000, '2025-01-13 16:00:00'),
(7, 3, 4, 5, 8000,  '2025-01-14 10:00:00'),
(8, 3, 5, 2, 30000, '2025-01-14 11:00:00'),
(9, 1, 1, 9, 5000,  '2025-01-15 12:00:00'),
(10,1, 2, 3, 25000, '2025-01-15 14:00:00'),

(1, 2, 3, 2, 10000, '2025-01-16 10:00:00'),
(2, 2, 4, 5, 15000, '2025-01-16 11:00:00'),
(3, 3, 5, 4, 7000,  '2025-01-17 09:30:00'),
(4, 3, 1, 6, 12000, '2025-01-17 13:00:00'),
(5, 1, 2, 3, 9000,  '2025-01-18 15:00:00'),
(6, 1, 3, 2, 20000, '2025-01-18 16:00:00'),
(7, 2, 4, 7, 8000,  '2025-01-19 10:00:00'),
(8, 2, 5, 1, 30000, '2025-01-19 11:00:00'),
(9, 3, 1, 4, 5000,  '2025-01-20 12:00:00'),
(10,3, 2, 2, 25000, '2025-01-20 14:00:00');

-- create table Reports
CREATE TABLE Reports(
    reportID INT PRIMARY KEY AUTO_INCREMENT,
    reportType VARCHAR(20) NOT NULL,
    user VARCHAR(50) NOT NULL,
    reportDescription TEXT NOT NULL
);

-- insert data dummy Reports
INSERT INTO Reports (reportType, user, reportDescription) VALUES
('Fraud', 'Andi Kuliner', 'Penipuan pembayaran pesanan katering'),
('Harassment', 'Budi Coffee', 'Pelanggan mengirim pesan kasar kepada kasir'),
('Other', 'Citra Fashion', 'Keluhan layanan pengiriman terlambat'),
('Violence', 'Dewi Laundry', 'Ancaman fisik terhadap pegawai toko'),
('Corruption', 'Eko Supplier', 'Pemotongan dana kerja sama tidak resmi'),

('Fraud', 'Fajar Elektronik', 'Pembayaran palsu menggunakan bukti transfer editan'),
('Hate Speech', 'Gita Bakery', 'Komentar menghina usaha lokal di media sosial'),
('Harassment', 'Hadi Workshop', 'Pelanggan melakukan pelecehan verbal'),
('Other', 'Intan Florist', 'Perselisihan kecil antar mitra usaha'),
('Violence', 'Joko Mart', 'Perusakan etalase toko'),

('Corruption', 'Kartika Event', 'Permintaan pungutan liar dalam perizinan'),
('Fraud', 'Lukman Printing', 'Penipuan invoice oleh pihak ketiga'),
('Harassment', 'Maya Salon', 'Pelanggan mengganggu karyawan'),
('Hate Speech', 'Nanda Media', 'Ujaran kebencian terhadap pemilik UMKM'),
('Other', 'Oki Frozen Food', 'Kesalahpahaman kontrak kerja'),

('Violence', 'Putri Petshop', 'Ancaman terhadap pegawai saat penagihan'),
('Fraud', 'Qori Skincare', 'Penjualan produk palsu mengatasnamakan toko'),
('Corruption', 'Rama Logistik', 'Suap untuk percepatan distribusi'),
('Harassment', 'Sinta Craft', 'Pelecehan melalui pesan online'),
('Other', 'Taufik Furniture', 'Komplain kualitas bahan'),

('Hate Speech', 'Umar Travel', 'Komentar diskriminatif terhadap jasa lokal'),
('Violence', 'Vina Catering', 'Keributan fisik dengan pelanggan'),
('Fraud', 'Wahyu Digital', 'Penipuan layanan pemasaran online'),
('Corruption', 'Yoga Distributor', 'Penggelapan dana titipan'),
('Harassment', 'Zahra Boutique', 'Pelanggan berkata tidak sopan'),

('Other', 'Andi Percetakan', 'Laporan umum terkait kerja sama'),
('Fraud', 'Bella Aksesoris', 'Pembatalan sepihak setelah pembayaran'),
('Violence', 'Chandra Bengkel', 'Perusakan fasilitas bengkel'),
('Hate Speech', 'Dian Studio', 'Komentar merendahkan UMKM kecil'),

('Harassment', 'Erik Fotografi', 'Pesan tidak pantas kepada admin'),
('Fraud', 'Fitri Snack', 'Pembelian fiktif dalam jumlah besar'),
('Corruption', 'Galih Property', 'Pungutan ilegal dalam sewa kios'),
('Other', 'Hana Hijab', 'Kesalahan pencatatan stok'),

('Violence', 'Irfan Seafood', 'Ancaman kekerasan saat penagihan'),
('Harassment', 'Jihan Wedding', 'Gangguan verbal kepada staf'),
('Fraud', 'Kevin Fashion', 'Penipuan reseller'),
('Corruption', 'Lia Logistics', 'Penyalahgunaan dana operasional'),
('Other', 'Miko Furniture', 'Keluhan kualitas pengiriman'),

('Hate Speech', 'Nisa Online Shop', 'Komentar ofensif di marketplace'),
('Violence', 'Oscar Mini Market', 'Perkelahian di area toko'),
('Harassment', 'Putra Tech Store', 'Pelanggan berkata kasar'),
('Fraud', 'Rani Cosmetic', 'Penjualan produk tiruan'),
('Other', 'Satria UMKM Center', 'Laporan umum terkait manajemen');

CREATE TABLE dailyProfitoss (
    dailyId INT AUTO_INCREMENT PRIMARY KEY,
    businessId INT NOT NULL,
    summaryDate DATE NOT NULL,
    dailyRevenue DECIMAL(15,2) DEFAULT 0,
    dailyCOGS DECIMAL(15,2) DEFAULT 0,
    dailyGrossProfit DECIMAL(15,2) DEFAULT 0,
    UNIQUE KEY (businessId, summaryDate),
    FOREIGN KEY (businessId) REFERENCES business(businessId)
);