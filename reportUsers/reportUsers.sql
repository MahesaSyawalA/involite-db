-- Report Users table

CREATE TABLE Reports(
    reportID INT PRIMARY KEY AUTO_INCREMENT,
    reportType ENUM('Violence', 'Harassment', 'Corruption', 'Other', 'Hate Speech', 'Fraud') NOT NULL,
    user VARCHAR(50) NOT NULL,
    reportDescription TEXT NOT NULL
);

SELECT @sql_mode;
SET sql_mode = 'STRICT_TRANS_TABLES';