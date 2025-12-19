-- Function untuk mengecek kepulangan karyawan

CREATE FUNCTION isEmployeePresence(p_clockIN TIME, p_clockOUT TIME)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE status VARCHAR(50);

    IF p_clockOUT IS NULL THEN
        SET status = 'Karyawan Tersebut belum Pulang';
    ELSEIF p_clockIN IS NULL THEN
        SET status = 'Karyawan tersebut tidak hadir ';
    ELSE 
        SET status = 'Karyawan Tersebut sudah Pulang';
    END IF;
    RETURN status;
END //

SELECT
    userID,
    presenceDate,
    clockIN,
    clockOUT,
    isEmployeePresence(clockIN, clockOUT) AS status_kehadiran
FROM employeePresence;
