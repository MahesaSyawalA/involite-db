CREATE TABLE Reports(
    reportID INT PRIMARY KEY AUTO_INCREMENT,
    reportType VARCHAR(20) NOT NULL,
    user VARCHAR(50) NOT NULL,
    reportDescription TEXT NOT NULL
);

SELECT @sql_mode;
SET sql_mode = 'STRICT_TRANS_TABLES';

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
