-- Transaction untuk memasukan laporan

START TRANSACTION;

INSERT INTO Reports (reportyType, user, reportDescription) VALUES
('[Tipe Laporan. 4 tipe yaitu, violence, Harassment, Corruption, Other, Hate Speech, Fraud', '[Nama User]', '[Deskripsi Laporan]');

COMMIT;

-- Example

START TRANSACTION;
INSERT INTO Reports (reportType, user, reportDescription) VALUES
('FraudAS', 'Andi Kuliner', 'Penipuan pembayaran pesanan katering');

COMMIT;