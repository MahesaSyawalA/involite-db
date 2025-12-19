-- Ranking untuk menampilkan kehadiran karyawan berdasarkan waktu absen masuk yang paling pagi 

SELECT
    userID,
    presenceDate,
    clockIN,
    RANK() OVER (PARTITION BY presenceDate ORDER BY clockIN ASC) AS Masuk_Paling_Awal
FROM employeePresence
WHERE clockIN IS NOT NULL


