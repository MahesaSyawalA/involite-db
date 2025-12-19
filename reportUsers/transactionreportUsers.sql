-- Transaction untuk memasukan laporan

START TRANSACTION;

INSERT INTO Reports (reportType, userId, description, businessId, createdAt) VALUES
('[Tipe Laporan. 4 tipe yaitu, violence, Harassment, Corruption, Other, Hate Speech, Fraud', 'ID user', '[Deskripsi Laporan]', 'Busines ID', 'Tanggal dibuatnya');

COMMIT;

-- Example

START TRANSACTION;
INSERT INTO Reports (reportType, userId, description, businessId, createdAt) VALUES
('Harassment', '3', 'Menghina viking', '2', '2024-10-1');

COMMIT;