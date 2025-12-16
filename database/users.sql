-- create table users
CREATE TABLE users (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    businessId INT,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100),
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    role ENUM('owner','akuntan','gudang','sales') NOT NULL
)

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


