CREATE TABLE logs (
    logId INT AUTO_INCREMENT PRIMARY KEY,

    businessId INT NOT NULL,

    action ENUM('CREATE','UPDATE','DELETE','LOGIN','LOGOUT') NOT NULL,
    entity VARCHAR(50) NOT NULL,     
    entityId INT NULL,                

    changes TEXT NULL,                 
    createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_logs_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)