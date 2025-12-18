-- Trigger untuk absen keluar

DELIMITER //

CREATE TRIGGER validate_clock
BEFORE UPDATE ON employeePresence
FOR EACH ROW
BEGIN
    IF NEW.clockOUT IS NOT NULL AND NEW.clockOUT <= NEW.clockIN THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Update gagal: jam clockOUT harus lebih dinantikan daripada jam clockIN.';
    END IF;
END//

DELIMITER;
