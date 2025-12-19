-- TABLE: daily_profit_loss
CREATE TABLE dailyProfitoss (
    dailyId INT AUTO_INCREMENT PRIMARY KEY,
    businessId INT NOT NULL,
    summaryDate DATE NOT NULL,
    
    -- Revenue & Cost
    dailyRevenue DECIMAL(15,2) DEFAULT 0,
    dailyCOGS DECIMAL(15,2) DEFAULT 0, -- Harga beli barang yang terjual
    dailyGrossProfit DECIMAL(15,2) DEFAULT 0,
    
    -- Inventory Value (akhir hari)
    endingInventoryValue DECIMAL(15,2) DEFAULT 0,
    
    -- Metadata
    lastUpdated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY (businessId, summaryDate),
    
    CONSTRAINT fk_dailypl_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

