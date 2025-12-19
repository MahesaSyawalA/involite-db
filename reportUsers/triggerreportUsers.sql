-- Validasi input agar sesuai dengan reportType yang telah ditentukan

DELIMITER //

CREATE TRIGGER validate_report_type
BEFORE INSERT ON Reports
FOR EACH ROW
BEGIN
    IF NEW.reportType NOT IN ('Violence','Harassment','Corruption','Other','Hate Speech','Fraud') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Update gagal: Tipe Laporan harus mencakup {Violence, Harassment, Corruption, Other, Hate Speech, Fraud}.';
    END IF;
END//  

DELIMITER;

-- Validasi tanggal pembuatan createdAt tidak boleh melebihi tanggal default 

CREATE TRIGGER trg_reports_validate_date
BEFORE INSERT ON Reports
FOR EACH ROW
BEGIN
    IF NEW.createdAt > CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tanggal laporan tidak boleh melebihi hari ini';
    END IF;
END;
