CREATE TABLE business (
    businessId INT AUTO_INCREMENT PRIMARY KEY,
    businessName VARCHAR(150) NOT NULL,
    ownerName VARCHAR(100) NOT NULL,
    businessType VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    phoneNumber VARCHAR(20) NOT NULL
);

CREATE TABLE users (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    businessId INT NOT NULL,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100),
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    role ENUM('owner','akuntan','gudang','sales') NOT NULL,

    CONSTRAINT fk_users_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE employeePresence (
    presenceId INT PRIMARY KEY AUTO_INCREMENT,
    userId INT NOT NULL,
    presenceDate DATE NOT NULL,
    clockIN TIME NOT NULL,
    clockOUT TIME,

    CONSTRAINT fk_employeePresence_user
        FOREIGN KEY (userId)
        REFERENCES users(userId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    UNIQUE (userId, presenceDate),
    CHECK (clockOUT IS NULL OR clockOUT > clockIN)
);

CREATE TABLE inventaries (
    invId INT AUTO_INCREMENT PRIMARY KEY,
    businessId INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(200) NOT NULL,
    price DECIMAL(15,2) DEFAULT 0, 
    purchaseDate DATE NOT NULL,
    status ENUM('active','inactive') NOT NULL DEFAULT 'active',

    CONSTRAINT fk_inventaries_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE items (
    itemsId INT AUTO_INCREMENT PRIMARY KEY,
    businessId INT NOT NULL, 
    itemName VARCHAR(150) NOT NULL, 
    category VARCHAR(100) NOT NULL, 
    purchasePrice DECIMAL(12,2) DEFAULT 0, 
    sellingPrice DECIMAL(12,2) DEFAULT 0, 
    stockQuantity INT NOT NULL, 
    movingStatus ENUM('FAST','SLOW','DEAD') NOT NULL,

    CONSTRAINT fk_items_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT 
);

CREATE TABLE inComingItems (
    iciId INT AUTO_INCREMENT PRIMARY KEY,

    itemsId INT NOT NULL,
    businessId INT NOT NULL,
    userId INT NOT NULL,

    quantity INT NOT NULL,
    unitPrice DECIMAL(15,2) DEFAULT 0,

    totalPurchase DECIMAL(15,2) GENERATED ALWAYS AS (quantity * unitPrice) STORED,

    inComingDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- relasi
    CONSTRAINT fk_ici_items
        FOREIGN KEY (itemsId)
        REFERENCES items(itemsId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_ici_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_ici_user
        FOREIGN KEY (userId)
        REFERENCES users(userId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE outComingItems (
    ociId INT AUTO_INCREMENT PRIMARY KEY,

    itemsId INT NOT NULL,
    businessId INT NOT NULL,
    userId INT NOT NULL,

    quantity INT NOT NULL,
    unitPrice DECIMAL(15,2) DEFAULT 0,

    totalSale DECIMAL(15,2) GENERATED ALWAYS AS (quantity * unitPrice) STORED,

    outComingDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- relasi 
    CONSTRAINT fk_oci_items
        FOREIGN KEY (itemsId)
        REFERENCES items(itemsId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_oci_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_oci_user
        FOREIGN KEY (userId)
        REFERENCES users(userId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE dailyProfitLoss (
    dailyId INT AUTO_INCREMENT PRIMARY KEY,
    businessId INT NOT NULL,
    summaryDate DATE NOT NULL,
    dailyRevenue DECIMAL(15,2) DEFAULT 0,
    dailyCOGS DECIMAL(15,2) DEFAULT 0,
    dailyGrossProfit DECIMAL(15,2) DEFAULT 0,
    UNIQUE KEY (businessId, summaryDate),
    FOREIGN KEY (businessId) REFERENCES business(businessId)
);