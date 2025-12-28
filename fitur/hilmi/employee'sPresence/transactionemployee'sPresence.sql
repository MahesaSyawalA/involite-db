-- Transaction untuk absen clockIN dan clockOUT

-- clockIN (Absen Masuk)
START TRANSACTION;

INSERT INTO employeePresence (userID, presenceDate, clockIN)
VALUES([userID], '[Tanggal Masuk]', '[Jam Masuk]')

COMMIT;
-- clockOUT (Absen Keluar)
START TRANSACTION

UPDATE EmployeePresence
SET clockOUT = '[Jam Keluar]'
WHERE userID = [userID] AND presenceDate = '[Tanggal Keluar]';

COMMIT;

-- Example for clockIN:

START TRANSACTION;

INSERT INTO employeePresence (userID, presenceDate, clockIN)
VALUES (3, '2025-10-02', '09:00:00')

COMMIT;
-- Dead End

-- Example for clockOUT

START TRANSACTION;

UPDATE employeePresence
SET clockOUT = '08:00:00'
WHERE userID = 1
AND presenceDate = '2025-12-01';


COMMIT;
-- Dead End


