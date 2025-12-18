-- Procedure untuk menentukan employee of the day

CREATE PROCEDURE getEmployeeOfTheDay(IN targetDate DATE)
BEGIN
    SELECT
        presenceDate,
        userID,
        clockIN
    FROM (
        SELECT 
            presenceDate,
            userID,
            clockIN,
            RANK() OVER (PARTITION BY presenceDate ORDER BY clockIN ASC) AS jam_masuk
            FROM employeePresence
            WHERE presenceDate = targetDate
    ) AS rankedPresence
    WHERE jam_masuk = 1;
END//
