CREATE TABLE Reports(
    reportId INT PRIMARY KEY AUTO_INCREMENT,
    reportType VARCHAR(20) NOT NULL,
    userId INT NOT NULL,
    description TEXT NOT NULL,
    businessId INT,
    createdAt DATE DEFAULT CURRENT_DATE
);


-- Default Date
INSERT INTO Reports (reportType, userId, description, businessId) VALUES
('Fraud', 1, 'Dugaan manipulasi laporan keuangan', 1),
('Harassment', 2, 'Pelecehan verbal oleh karyawan', 1),
('Corruption', 3, 'Indikasi korupsi pembelian barang', 2),
('Violence', 4, 'Ancaman kekerasan di kantor', 2),
('Other', 5, 'Pelanggaran SOP internal', 3),

('Fraud', 6, 'Transaksi fiktif', 1),
('Harassment', 7, 'Perilaku tidak sopan', 2),
('Other', 8, 'Kesalahan stok', 3),
('Violence', 9, 'Perkelahian antar karyawan', 1),
('Corruption', 10, 'Suap vendor', 2),

('Fraud', 11, 'Penyalahgunaan dana', 3),
('Harassment', 12, 'Intimidasi atasan', 1),
('Other', 13, 'Kesalahan input data', 2),
('Violence', 14, 'Ancaman fisik', 3),
('Corruption', 15, 'Penggelapan dana', 1),

('Fraud', 16, 'Laporan penjualan tidak valid', 2),
('Harassment', 17, 'Diskriminasi kerja', 3),
('Other', 18, 'Dokumen laporan hilang', 1),
('Violence', 19, 'Tindakan agresif', 2),
('Corruption', 20, 'Penyalahgunaan aset', 3),

('Fraud', 21, 'Pemalsuan transaksi', 1),
('Harassment', 22, 'Komentar tidak pantas', 2),
('Other', 23, 'Error sistem laporan', 3),
('Violence', 24, 'Ancaman verbal', 1),
('Corruption', 25, 'Kolusi vendor', 2);


-- Tanggal  yang ditentukan
INSERT INTO Reports (reportType, userId, description, businessId, createdAt) VALUES
('Fraud', 26, 'Manipulasi data penjualan', 3, '2024-07-01'),
('Harassment', 27, 'Tekanan kerja berlebihan', 1, '2024-07-03'),
('Other', 28, 'Laporan keuangan terlambat', 2, '2024-07-05'),
('Violence', 29, 'Perilaku kasar di gudang', 3, '2024-07-08'),
('Corruption', 30, 'Penyalahgunaan jabatan', 1, '2024-07-10'),

('Fraud', 31, 'Pengeluaran fiktif', 2, '2024-08-01'),
('Harassment', 32, 'Ucapan merendahkan', 3, '2024-08-03'),
('Other', 33, 'Kesalahan inventaris', 1, '2024-08-05'),
('Violence', 34, 'Perusakan fasilitas', 2, '2024-08-07'),
('Corruption', 35, 'Transaksi ilegal vendor', 3, '2024-08-09'),

('Fraud', 36, 'Duplikasi laporan', 1, '2024-09-01'),
('Harassment', 37, 'Pelecehan via pesan', 2, '2024-09-02'),
('Other', 38, 'Laporan tidak lengkap', 3, '2024-09-03'),
('Violence', 39, 'Ancaman ke manajemen', 1, '2024-09-04'),
('Corruption', 40, 'Mark-up harga', 2, '2024-09-05'),

('Fraud', 41, 'Rekayasa laba rugi', 3, '2024-10-01'),
('Harassment', 42, 'Lingkungan kerja toksik', 1, '2024-10-02'),
('Other', 43, 'Kesalahan arsip', 2, '2024-10-03'),
('Violence', 44, 'Pertengkaran fisik', 3, '2024-10-04'),
('Corruption', 45, 'Pemotongan dana ilegal', 1, '2024-10-05'),

('Fraud', 46, 'Pendapatan tidak sesuai', 2, '2024-11-01'),
('Harassment', 47, 'Ancaman psikologis', 3, '2024-11-02'),
('Other', 48, 'Data laporan rusak', 1, '2024-11-03'),
('Violence', 49, 'Intimidasi kerja', 2, '2024-11-04'),
('Corruption', 50, 'Penyalahgunaan dana proyek', 3, '2024-11-05');


