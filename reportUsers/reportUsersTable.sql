CREATE TABLE Reports(
    reportId INT PRIMARY KEY AUTO_INCREMENT,
    reportType VARCHAR(20) NOT NULL,
    userId VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    businessId INT,
    createdAt DATE DEFAULT CURRENT_DATE
);


-- Default Date
INSERT INTO Reports (reportType, userId, description, businessId) VALUES
('Fraud', 'U001', 'Dugaan manipulasi laporan keuangan', 1),
('Harassment', 'U002', 'Pelecehan verbal oleh karyawan', 1),
('Corruption', 'U003', 'Indikasi korupsi pembelian barang', 2),
('Violence', 'U004', 'Ancaman kekerasan di kantor', 2),
('Other', 'U005', 'Pelanggaran SOP internal', 3),

('Fraud', 'U006', 'Transaksi fiktif', 1),
('Harassment', 'U007', 'Perilaku tidak sopan', 2),
('Other', 'U008', 'Kesalahan stok', 3),
('Violence', 'U009', 'Perkelahian antar karyawan', 1),
('Corruption', 'U010', 'Suap vendor', 2),

('Fraud', 'U011', 'Penyalahgunaan dana', 3),
('Harassment', 'U012', 'Intimidasi atasan', 1),
('Other', 'U013', 'Kesalahan input data', 2),
('Violence', 'U014', 'Ancaman fisik', 3),
('Corruption', 'U015', 'Penggelapan dana', 1),

('Fraud', 'U016', 'Laporan penjualan tidak valid', 2),
('Harassment', 'U017', 'Diskriminasi kerja', 3),
('Other', 'U018', 'Dokumen laporan hilang', 1),
('Violence', 'U019', 'Tindakan agresif', 2),
('Corruption', 'U020', 'Penyalahgunaan aset', 3),

('Fraud', 'U021', 'Pemalsuan transaksi', 1),
('Harassment', 'U022', 'Komentar tidak pantas', 2),
('Other', 'U023', 'Error sistem laporan', 3),
('Violence', 'U024', 'Ancaman verbal', 1),
('Corruption', 'U025', 'Kolusi vendor', 2);

-- Input Date
INSERT INTO Reports (reportType, userId, description, businessId, createdAt) VALUES
('Fraud', 'U026', 'Manipulasi data penjualan', 3, '2024-07-01'),
('Harassment', 'U027', 'Tekanan kerja berlebihan', 1, '2024-07-03'),
('Other', 'U028', 'Laporan keuangan terlambat', 2, '2024-07-05'),
('Violence', 'U029', 'Perilaku kasar di gudang', 3, '2024-07-08'),
('Corruption', 'U030', 'Penyalahgunaan jabatan', 1, '2024-07-10'),

('Fraud', 'U031', 'Pengeluaran fiktif', 2, '2024-08-01'),
('Harassment', 'U032', 'Ucapan merendahkan', 3, '2024-08-03'),
('Other', 'U033', 'Kesalahan inventaris', 1, '2024-08-05'),
('Violence', 'U034', 'Perusakan fasilitas', 2, '2024-08-07'),
('Corruption', 'U035', 'Transaksi ilegal vendor', 3, '2024-08-09'),

('Fraud', 'U036', 'Duplikasi laporan', 1, '2024-09-01'),
('Harassment', 'U037', 'Pelecehan via pesan', 2, '2024-09-02'),
('Other', 'U038', 'Laporan tidak lengkap', 3, '2024-09-03'),
('Violence', 'U039', 'Ancaman ke manajemen', 1, '2024-09-04'),
('Corruption', 'U040', 'Mark-up harga', 2, '2024-09-05'),

('Fraud', 'U041', 'Rekayasa laba rugi', 3, '2024-10-01'),
('Harassment', 'U042', 'Lingkungan kerja toksik', 1, '2024-10-02'),
('Other', 'U043', 'Kesalahan arsip', 2, '2024-10-03'),
('Violence', 'U044', 'Pertengkaran fisik', 3, '2024-10-04'),
('Corruption', 'U045', 'Pemotongan dana ilegal', 1, '2024-10-05'),

('Fraud', 'U046', 'Pendapatan tidak sesuai', 2, '2024-11-01'),
('Harassment', 'U047', 'Ancaman psikologis', 3, '2024-11-02'),
('Other', 'U048', 'Data laporan rusak', 1, '2024-11-03'),
('Violence', 'U049', 'Intimidasi kerja', 2, '2024-11-04'),
('Corruption', 'U050', 'Penyalahgunaan dana proyek', 3, '2024-11-05');


