CREATE DATABASE db_involite;

USE db_involite;

DELIMITER $$
CREATE FUNCTION FormatRupiah(
    amount DECIMAL(15,2)
)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE formatted VARCHAR(50);
    
    IF amount IS NULL THEN
        RETURN 'Rp 0';
    END IF;
    
    SET formatted = CONCAT('Rp ', FORMAT(amount, 0));
    
    RETURN formatted;
END$$

DELIMITER ;

-- Table Business
CREATE TABLE business (
    businessId INT AUTO_INCREMENT PRIMARY KEY,
    businessName VARCHAR(150) NOT NULL,
    ownerName VARCHAR(100) NOT NULL,
    businessType VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    phoneNumber VARCHAR(20) NOT NULL
);

DELIMITER $$

CREATE TRIGGER trg_business_after_insert
AFTER INSERT ON business
FOR EACH ROW
BEGIN
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        NEW.businessId,
        'CREATE',
        'business',
        NEW.businessId,
        JSON_OBJECT(
            'businessName', NEW.businessName,
            'ownerName', NEW.ownerName,
            'businessType', NEW.businessType,
            'address', NEW.address,
            'phoneNumber', NEW.phoneNumber
        )
    );
END$$


CREATE TRIGGER trg_business_after_update
AFTER UPDATE ON business
FOR EACH ROW
BEGIN
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        NEW.businessId,
        'UPDATE',
        'business',
        NEW.businessId,
        JSON_OBJECT(
            'businessName', JSON_OBJECT('old', OLD.businessName, 'new', NEW.businessName),
            'ownerName', JSON_OBJECT('old', OLD.ownerName, 'new', NEW.ownerName),
            'businessType', JSON_OBJECT('old', OLD.businessType, 'new', NEW.businessType),
            'address', JSON_OBJECT('old', OLD.address, 'new', NEW.address),
            'phoneNumber', JSON_OBJECT('old', OLD.phoneNumber, 'new', NEW.phoneNumber)
        )
    );
END$$


CREATE TRIGGER trg_business_before_delete
BEFORE DELETE ON business
FOR EACH ROW
BEGIN
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        OLD.businessId,
        'DELETE',
        'business',
        OLD.businessId,
        JSON_OBJECT(
            'businessName', OLD.businessName,
            'ownerName', OLD.ownerName,
            'businessType', OLD.businessType,
            'address', OLD.address,
            'phoneNumber', OLD.phoneNumber
        )
    );
END$$

DELIMITER ;

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
        ON DELETE CASCADE
);

DELIMITER $$

CREATE TRIGGER trg_users_after_insert
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        NEW.businessId,
        'CREATE',
        'users',
        NEW.userId,
        JSON_OBJECT(
            'firstName', NEW.firstName,
            'lastName', NEW.lastName,
            'email', NEW.email,
            'phone', NEW.phone,
            'role', NEW.role
        )
    );
END $$

CREATE TRIGGER trg_users_after_update
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        NEW.businessId,
        'UPDATE',
        'users',
        NEW.userId,
        JSON_OBJECT(
            'firstName', JSON_OBJECT('old', OLD.firstName, 'new', NEW.firstName),
            'lastName',  JSON_OBJECT('old', OLD.lastName,  'new', NEW.lastName),
            'email',     JSON_OBJECT('old', OLD.email,     'new', NEW.email),
            'phone',     JSON_OBJECT('old', OLD.phone,     'new', NEW.phone),
            'role',      JSON_OBJECT('old', OLD.role,      'new', NEW.role)
        )
    );
END $$

CREATE TRIGGER trg_users_before_delete
BEFORE DELETE ON users
FOR EACH ROW
BEGIN
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        OLD.businessId,
        'DELETE',
        'users',
        OLD.userId,
        JSON_OBJECT(
            'firstName', OLD.firstName,
            'lastName', OLD.lastName,
            'email', OLD.email,
            'phone', OLD.phone,
            'role', OLD.role
        )
    );
END $$

DELIMITER ;

-- Inventaries
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
        ON DELETE CASCADE
);

DELIMITER $$

CREATE TRIGGER trg_inventaries_after_insert
AFTER INSERT ON inventaries
FOR EACH ROW
BEGIN
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        NEW.businessId,
        'CREATE',
        'inventaries',
        NEW.invId,
        JSON_OBJECT(
            'name', NEW.name,
            'description', NEW.description,
            'price', NEW.price,
            'purchaseDate', NEW.purchaseDate,
            'status', NEW.status
        )
    );
END $$

CREATE TRIGGER trg_inventaries_after_update
AFTER UPDATE ON inventaries
FOR EACH ROW
BEGIN
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        NEW.businessId,
        'UPDATE',
        'inventaries',
        NEW.invId,
        JSON_OBJECT(
            'name', JSON_OBJECT('old', OLD.name, 'new', NEW.name),
            'description', JSON_OBJECT('old', OLD.description, 'new', NEW.description),
            'price', JSON_OBJECT('old', OLD.price, 'new', NEW.price),
            'purchaseDate', JSON_OBJECT('old', OLD.purchaseDate, 'new', NEW.purchaseDate),
            'status', JSON_OBJECT('old', OLD.status, 'new', NEW.status)
        )
    );
END $$

CREATE TRIGGER trg_inventaries_before_delete
BEFORE DELETE ON inventaries
FOR EACH ROW
BEGIN
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        OLD.businessId,
        'DELETE',
        'inventaries',
        OLD.invId,
        JSON_OBJECT(
            'name', OLD.name,
            'description', OLD.description,
            'price', OLD.price,
            'purchaseDate', OLD.purchaseDate,
            'status', OLD.status
        )
    );
END $$

CREATE FUNCTION fn_total_inventary_value(p_businessId INT)
RETURNS BIGINT
DETERMINISTIC
BEGIN
    DECLARE total BIGINT;

    SELECT COALESCE(SUM(price), 0)
    INTO total
    FROM inventaries
    WHERE businessId = p_businessId
      AND status = 'active';

    RETURN total;
END $$

CREATE PROCEDURE sp_add_inventary(
    IN p_businessId INT,
    IN p_name VARCHAR(150),
    IN p_description VARCHAR(200),
    IN p_price INT,
    IN p_purchaseDate DATE
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO inventaries (
        businessId,
        name,
        description,
        price,
        purchaseDate,
        status
    ) VALUES (
        p_businessId,
        p_name,
        p_description,
        p_price,
        p_purchaseDate,
        'active'
    );

    COMMIT;
END $$

CREATE TRIGGER trg_check_inventary_price
BEFORE INSERT ON inventaries
FOR EACH ROW
BEGIN
    IF NEW.price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Harga inventaris harus lebih dari 0';
    END IF;
END $$

DELIMITER ;

CREATE VIEW vw_inventary_ranking AS
SELECT
    invId,
    businessId,
    name,
    price,
    RANK() OVER (
        PARTITION BY businessId
        ORDER BY price DESC
    ) AS price_rank
FROM inventaries
WHERE status = 'active';

-- VIEW DASHBOARD INVENTARIES
CREATE VIEW vw_dashboard_inventaries AS
SELECT
    invId,
    businessId,
    name,
    description,
    price,
    purchaseDate,
    status
FROM inventaries
WHERE status = 'active';

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
        ON DELETE CASCADE 
);

DELIMITER $$

CREATE TRIGGER trg_items_after_insert
AFTER INSERT ON items
FOR EACH ROW
BEGIN
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        NEW.businessId,
        'CREATE',
        'items',
        NEW.itemsId,
        JSON_OBJECT(
            'itemName', NEW.itemName,
            'category', NEW.category,
            'purchasePrice', NEW.purchasePrice,
            'sellingPrice', NEW.sellingPrice,
            'stockQuantity', NEW.stockQuantity,
            'movingStatus', NEW.movingStatus
        )
    );
END$$

CREATE TRIGGER trg_items_after_update
AFTER UPDATE ON items
FOR EACH ROW
BEGIN
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        NEW.businessId,
        'UPDATE',
        'items',
        NEW.itemsId,
        JSON_OBJECT(
            'itemName', JSON_OBJECT('old', OLD.itemName, 'new', NEW.itemName),
            'category', JSON_OBJECT('old', OLD.category, 'new', NEW.category),
            'purchasePrice', JSON_OBJECT('old', OLD.purchasePrice, 'new', NEW.purchasePrice),
            'sellingPrice', JSON_OBJECT('old', OLD.sellingPrice, 'new', NEW.sellingPrice),
            'stockQuantity', JSON_OBJECT('old', OLD.stockQuantity, 'new', NEW.stockQuantity),
            'movingStatus', JSON_OBJECT('old', OLD.movingStatus, 'new', NEW.movingStatus)
        )
    );
END$$

CREATE TRIGGER trg_items_before_delete
BEFORE DELETE ON items
FOR EACH ROW
BEGIN
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        OLD.businessId,
        'DELETE',
        'items',
        OLD.itemsId,
        JSON_OBJECT(
            'itemName', OLD.itemName,
            'category', OLD.category,
            'purchasePrice', OLD.purchasePrice,
            'sellingPrice', OLD.sellingPrice,
            'stockQuantity', OLD.stockQuantity,
            'movingStatus', OLD.movingStatus
        )
    );
END$$

DELIMITER ;

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
        ON DELETE CASCADE,

    CONSTRAINT fk_ici_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_ici_user
        FOREIGN KEY (userId)
        REFERENCES users(userId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
-- Hapus trigger yang redundan
DROP TRIGGER IF EXISTS UpdateStockAfterIncoming;
DROP TRIGGER IF EXISTS trg_after_incomingitems_insert;
DROP TRIGGER IF EXISTS RestoreStockAfterIncomingDelete;
DROP TRIGGER IF EXISTS trg_after_incomingitems_delete;

DELIMITER $$

-- Trigger UPDATE untuk logs
CREATE TRIGGER trg_inComingItems_after_update
AFTER UPDATE ON inComingItems
FOR EACH ROW
BEGIN
    DECLARE v_quantity_diff INT;
    DECLARE v_totalPurchase_diff DECIMAL(15,2);
    DECLARE v_old_purchase_price DECIMAL(15,2);
    DECLARE v_new_purchase_price DECIMAL(15,2);
    DECLARE v_current_stock INT;
    
    -- Log update
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        NEW.businessId,
        'UPDATE',
        'inComingItems',
        NEW.iciId,
        JSON_OBJECT(
            'itemsId', JSON_OBJECT('old', OLD.itemsId, 'new', NEW.itemsId),
            'userId', JSON_OBJECT('old', OLD.userId, 'new', NEW.userId),
            'quantity', JSON_OBJECT('old', OLD.quantity, 'new', NEW.quantity),
            'unitPrice', JSON_OBJECT('old', OLD.unitPrice, 'new', NEW.unitPrice),
            'totalPurchase', JSON_OBJECT('old', OLD.totalPurchase, 'new', NEW.totalPurchase),
            'inComingDate', JSON_OBJECT('old', OLD.inComingDate, 'new', NEW.inComingDate)
        )
    );
    
    -- Update stok dan COGS jika ada perubahan quantity atau unitPrice
    IF OLD.quantity != NEW.quantity OR OLD.unitPrice != NEW.unitPrice THEN
        SET v_quantity_diff = NEW.quantity - OLD.quantity;
        SET v_totalPurchase_diff = NEW.totalPurchase - OLD.totalPurchase;
        
        -- Update stok
        UPDATE items 
        SET stockQuantity = stockQuantity + v_quantity_diff
        WHERE itemsId = NEW.itemsId;
        
        -- Update dailyProfitLoss (COGS)
        IF v_totalPurchase_diff != 0 THEN
            UPDATE dailyProfitLoss
            SET 
                dailyCOGS = dailyCOGS + v_totalPurchase_diff,
                dailyGrossProfit = dailyRevenue - dailyCOGS
            WHERE businessId = NEW.businessId 
              AND summaryDate = DATE(NEW.inComingDate);
        END IF;
    END IF;
END$$

-- Trigger DELETE untuk logs dan update stok
CREATE TRIGGER trg_inComingItems_before_delete
BEFORE DELETE ON inComingItems
FOR EACH ROW
BEGIN
    DECLARE v_current_purchase_price DECIMAL(15,2);
    DECLARE v_current_stock INT;
    DECLARE v_new_avg_price DECIMAL(15,2);
    
    -- Log penghapusan
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        OLD.businessId,
        'DELETE',
        'inComingItems',
        OLD.iciId,
        JSON_OBJECT(
            'itemsId', OLD.itemsId,
            'userId', OLD.userId,
            'quantity', OLD.quantity,
            'unitPrice', OLD.unitPrice,
            'totalPurchase', OLD.totalPurchase,
            'inComingDate', OLD.inComingDate
        )
    );
    
    -- Ambil data current untuk kalkulasi rata-rata
    SELECT purchasePrice, stockQuantity 
    INTO v_current_purchase_price, v_current_stock
    FROM items 
    WHERE itemsId = OLD.itemsId;
    
    -- Hitung harga rata-rata baru setelah penghapusan (reverse weighted average)
    IF v_current_stock - OLD.quantity > 0 THEN
        SET v_new_avg_price = ((v_current_purchase_price * v_current_stock) - (OLD.unitPrice * OLD.quantity)) 
                               / (v_current_stock - OLD.quantity);
    ELSE
        SET v_new_avg_price = 0;
    END IF;
    
    -- Update stok dan harga beli
    UPDATE items 
    SET 
        stockQuantity = stockQuantity - OLD.quantity,
        purchasePrice = ROUND(GREATEST(v_new_avg_price, 0), 2)
    WHERE itemsId = OLD.itemsId;
    
    -- Update moving status
    UPDATE items
    SET movingStatus = CASE
        WHEN (stockQuantity - OLD.quantity) > 100 THEN 'FAST'
        WHEN (stockQuantity - OLD.quantity) BETWEEN 20 AND 100 THEN 'SLOW'
        ELSE 'DEAD'
    END
    WHERE itemsId = OLD.itemsId;
    
    -- Update dailyProfitLoss (kurangi COGS)
    UPDATE dailyProfitLoss
    SET 
        dailyCOGS = dailyCOGS - OLD.totalPurchase,
        dailyGrossProfit = dailyRevenue - dailyCOGS
    WHERE businessId = OLD.businessId 
      AND summaryDate = DATE(OLD.inComingDate);
END$$

-- Trigger INSERT untuk logs
CREATE TRIGGER trg_inComingItems_after_insert
AFTER INSERT ON inComingItems
FOR EACH ROW
BEGIN
    -- Log insert
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        NEW.businessId,
        'INSERT',
        'inComingItems',
        NEW.iciId,
        JSON_OBJECT(
            'itemsId', NEW.itemsId,
            'userId', NEW.userId,
            'quantity', NEW.quantity,
            'unitPrice', NEW.unitPrice,
            'totalPurchase', NEW.totalPurchase,
            'inComingDate', NEW.inComingDate
        )
    );
    
    -- Update dailyProfitLoss (tambah COGS)
    INSERT INTO dailyProfitLoss (
        businessId,
        summaryDate,
        dailyRevenue,
        dailyCOGS,
        dailyGrossProfit
    ) VALUES (
        NEW.businessId,
        DATE(NEW.inComingDate),
        0,
        NEW.totalPurchase,
        -NEW.totalPurchase
    )
    ON DUPLICATE KEY UPDATE
        dailyCOGS = dailyCOGS + NEW.totalPurchase,
        dailyGrossProfit = dailyRevenue - dailyCOGS;
END$$

-- Procedure untuk mendapatkan ranking stok
CREATE PROCEDURE GetStockRanking(
    IN p_businessId INT
)
BEGIN
    SELECT 
        RANK() OVER (ORDER BY stockQuantity DESC) AS peringkat,
        itemName AS nama_barang,
        category AS kategori,
        stockQuantity AS jumlah_stok,
        movingStatus AS status_pergerakan,
        FormatRupiah(purchasePrice) AS harga_beli,
        FormatRupiah(sellingPrice) AS harga_jual,
        FormatRupiah(stockQuantity * sellingPrice) AS nilai_stok_total
    FROM items
    WHERE businessId = p_businessId
    ORDER BY stockQuantity DESC;
END $$

-- Procedure utama untuk insert barang masuk
CREATE PROCEDURE InsertIncomingItem(
    IN p_itemsId INT,
    IN p_businessId INT,
    IN p_userId INT,
    IN p_quantity INT,
    IN p_unitPrice DECIMAL(15,2)
)
BEGIN
    DECLARE v_current_price DECIMAL(15,2);
    DECLARE v_new_avg_price DECIMAL(15,2);
    DECLARE v_current_stock INT;
    DECLARE v_total_purchase DECIMAL(15,2);
    DECLARE v_new_ici_id INT;
    DECLARE v_moving_status VARCHAR(10);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Lock row dan ambil data current
    SELECT purchasePrice, stockQuantity 
    INTO v_current_price, v_current_stock
    FROM items 
    WHERE itemsId = p_itemsId 
      AND businessId = p_businessId
    FOR UPDATE;
    
    IF v_current_price IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Item tidak ditemukan';
    END IF;
    
    -- Validasi input
    IF p_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Quantity harus lebih dari 0';
    END IF;
    
    IF p_unitPrice < 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Harga unit tidak boleh negatif';
    END IF;
    
    -- Hitung total purchase
    SET v_total_purchase = p_quantity * p_unitPrice;
    
    -- Hitung harga rata-rata baru (weighted average)
    IF v_current_stock + p_quantity > 0 THEN
        SET v_new_avg_price = ((v_current_price * v_current_stock) + (p_unitPrice * p_quantity)) 
                               / (v_current_stock + p_quantity);
    ELSE
        SET v_new_avg_price = p_unitPrice;
    END IF;
    
    -- Tentukan moving status baru
    SET v_moving_status = CASE
        WHEN (v_current_stock + p_quantity) > 100 THEN 'FAST'
        WHEN (v_current_stock + p_quantity) BETWEEN 20 AND 100 THEN 'SLOW'
        ELSE 'DEAD'
    END;
    
    -- Insert ke inComingItems
    INSERT INTO inComingItems (
        itemsId,
        businessId,
        userId,
        quantity,
        unitPrice,
        totalPurchase,
        inComingDate
    ) VALUES (
        p_itemsId,
        p_businessId,
        p_userId,
        p_quantity,
        p_unitPrice,
        v_total_purchase,
        NOW()
    );
    
    SET v_new_ici_id = LAST_INSERT_ID();
    
    -- Update items: stok, harga beli rata-rata, dan moving status
    UPDATE items 
    SET 
        stockQuantity = stockQuantity + p_quantity,
        purchasePrice = ROUND(v_new_avg_price, 2),
        movingStatus = v_moving_status
    WHERE itemsId = p_itemsId;
    
    -- Update dailyProfitLoss dalam satu transaksi
    INSERT INTO dailyProfitLoss (
        businessId,
        summaryDate,
        dailyRevenue,
        dailyCOGS,
        dailyGrossProfit
    ) VALUES (
        p_businessId,
        CURDATE(),
        0,
        v_total_purchase,
        -v_total_purchase
    )
    ON DUPLICATE KEY UPDATE
        dailyCOGS = dailyCOGS + v_total_purchase,
        dailyGrossProfit = dailyRevenue - dailyCOGS;
    
    COMMIT;
    
    -- Return hasil
    SELECT 
        'SUCCESS' AS status,
        'Barang masuk berhasil' AS message,
        v_new_ici_id AS incoming_id,
        v_current_stock AS stock_before,
        (v_current_stock + p_quantity) AS stock_after,
        FORMAT(v_current_price, 2) AS old_price,
        FORMAT(v_new_avg_price, 2) AS new_avg_price,
        FORMAT(p_unitPrice, 2) AS input_price,
        v_moving_status AS moving_status,
        FormatRupiah(v_total_purchase) AS total_purchase;
END$$

DELIMITER ;

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
        ON DELETE CASCADE,

    CONSTRAINT fk_oci_business
        FOREIGN KEY (businessId)
        REFERENCES business(businessId)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_oci_user
        FOREIGN KEY (userId)
        REFERENCES users(userId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Hapus trigger yang redundan
DROP TRIGGER IF EXISTS UpdateStockAfterOutgoing;
DROP TRIGGER IF EXISTS trg_after_outcomingitems_insert;
DROP TRIGGER IF EXISTS RestoreStockAfterOutgoingDelete;
DROP TRIGGER IF EXISTS trg_after_outcomingitems_delete;

DELIMITER $$

-- Trigger UPDATE untuk logs
CREATE TRIGGER trg_outComingItems_after_update
AFTER UPDATE ON outComingItems
FOR EACH ROW
BEGIN
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        NEW.businessId,
        'UPDATE',
        'outComingItems',
        NEW.ociId,
        JSON_OBJECT(
            'itemsId', JSON_OBJECT('old', OLD.itemsId, 'new', NEW.itemsId),
            'userId', JSON_OBJECT('old', OLD.userId, 'new', NEW.userId),
            'quantity', JSON_OBJECT('old', OLD.quantity, 'new', NEW.quantity),
            'unitPrice', JSON_OBJECT('old', OLD.unitPrice, 'new', NEW.unitPrice),
            'totalSale', JSON_OBJECT('old', OLD.totalSale, 'new', NEW.totalSale),
            'outComingDate', JSON_OBJECT('old', OLD.outComingDate, 'new', NEW.outComingDate)
        )
    );
END $$

-- Trigger DELETE untuk logs
CREATE TRIGGER trg_outComingItems_before_delete
BEFORE DELETE ON outComingItems
FOR EACH ROW
BEGIN
    -- Log penghapusan
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        OLD.businessId,
        'DELETE',
        'outComingItems',
        OLD.ociId,
        JSON_OBJECT(
            'itemsId', OLD.itemsId,
            'userId', OLD.userId,
            'quantity', OLD.quantity,
            'unitPrice', OLD.unitPrice,
            'totalSale', OLD.totalSale,
            'outComingDate', OLD.outComingDate
        )
    );
    
    -- Kembalikan stok
    UPDATE items 
    SET stockQuantity = stockQuantity + OLD.quantity
    WHERE itemsId = OLD.itemsId;
    
    -- Update dailyProfitLoss
    UPDATE dailyProfitLoss
    SET 
        dailyRevenue = dailyRevenue - OLD.totalSale,
        dailyGrossProfit = dailyRevenue - dailyCOGS
    WHERE businessId = OLD.businessId 
      AND summaryDate = DATE(OLD.outComingDate);
END $$

-- Trigger INSERT untuk logs
CREATE TRIGGER trg_outComingItems_after_insert
AFTER INSERT ON outComingItems
FOR EACH ROW
BEGIN
    -- Log insert
    INSERT INTO logs (
        businessId,
        action,
        entity,
        entityId,
        changes
    ) VALUES (
        NEW.businessId,
        'INSERT',
        'outComingItems',
        NEW.ociId,
        JSON_OBJECT(
            'itemsId', NEW.itemsId,
            'userId', NEW.userId,
            'quantity', NEW.quantity,
            'unitPrice', NEW.unitPrice,
            'totalSale', NEW.totalSale,
            'outComingDate', NEW.outComingDate
        )
    );
    
    -- Update dailyProfitLoss dengan cara yang benar
    INSERT INTO dailyProfitLoss (
        businessId,
        summaryDate,
        dailyRevenue,
        dailyCOGS,
        dailyGrossProfit
    ) VALUES (
        NEW.businessId,
        DATE(NEW.outComingDate),
        NEW.totalSale,
        0,
        NEW.totalSale
    )
    ON DUPLICATE KEY UPDATE
        dailyRevenue = dailyRevenue + NEW.totalSale,
        dailyGrossProfit = dailyRevenue + NEW.totalSale - dailyCOGS;
END $$

-- Procedure untuk mendapatkan barang terlaris
CREATE PROCEDURE GetBestSellingItems(
    IN p_businessId INT
)
BEGIN
    SELECT 
        RANK() OVER (ORDER BY SUM(oci.quantity) DESC) AS ranking,
        i.itemName AS nama_barang,
        i.category AS kategori,
        SUM(oci.quantity) AS total_terjual,
        COUNT(oci.ociId) AS jumlah_transaksi,
        FORMAT(AVG(oci.unitPrice), 0) AS harga_rata_rata,
        FormatRupiah(SUM(oci.totalSale)) AS total_penjualan
    FROM outComingItems oci
    JOIN items i ON oci.itemsId = i.itemsId
    WHERE oci.businessId = p_businessId
    GROUP BY i.itemsId, i.itemName, i.category
    ORDER BY total_terjual DESC;
END $$

-- Procedure utama untuk insert barang keluar (MENGGANTI trigger lama)
CREATE PROCEDURE InsertOutComingItem(
    IN p_itemsId INT,
    IN p_businessId INT,
    IN p_userId INT,
    IN p_quantity INT,
    IN p_unitPrice DECIMAL(15,2)
)
BEGIN
    DECLARE v_currentStock INT;
    DECLARE v_purchasePrice DECIMAL(15,2);
    DECLARE v_totalSale DECIMAL(15,2);
    DECLARE v_newOciId INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Lock dan cek stok
    SELECT stockQuantity, purchasePrice
    INTO v_currentStock, v_purchasePrice
    FROM items
    WHERE itemsId = p_itemsId
      AND businessId = p_businessId
    FOR UPDATE;

    IF v_currentStock IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Item tidak ditemukan';
    END IF;

    IF v_currentStock < p_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stok tidak mencukupi';
    END IF;

    -- Hitung total sale
    SET v_totalSale = p_quantity * p_unitPrice;

    -- Insert ke outComingItems
    INSERT INTO outComingItems (
        itemsId,
        businessId,
        userId,
        quantity,
        unitPrice,
        totalSale,
        outComingDate
    ) VALUES (
        p_itemsId,
        p_businessId,
        p_userId,
        p_quantity,
        p_unitPrice,
        v_totalSale,
        NOW()
    );
    
    SET v_newOciId = LAST_INSERT_ID();

    -- Update stok
    UPDATE items 
    SET stockQuantity = stockQuantity - p_quantity
    WHERE itemsId = p_itemsId;

    -- Update dailyProfitLoss dalam satu transaksi
    INSERT INTO dailyProfitLoss (
        businessId,
        summaryDate,
        dailyRevenue,
        dailyCOGS,
        dailyGrossProfit
    ) VALUES (
        p_businessId,
        CURDATE(),
        v_totalSale,
        0,
        v_totalSale
    )
    ON DUPLICATE KEY UPDATE
        dailyRevenue = dailyRevenue + v_totalSale,
        dailyGrossProfit = dailyRevenue + v_totalSale - dailyCOGS;

    COMMIT;

    -- Return hasil
    SELECT
        'SUCCESS' AS status,
        'Barang keluar berhasil' AS message,
        v_newOciId AS outComing_id,
        v_currentStock AS stock_before,
        (v_currentStock - p_quantity) AS stock_after,
        FormatRupiah(v_purchasePrice) AS purchase_price,
        FormatRupiah(p_unitPrice) AS sale_price,
        FormatRupiah(v_totalSale) AS total_sale;

END$$

-- Trigger untuk UPDATE (jika data outComingItems diupdate)
CREATE TRIGGER trg_outComingItems_after_update_complete
AFTER UPDATE ON outComingItems
FOR EACH ROW
BEGIN
    DECLARE v_quantity_diff INT;
    DECLARE v_totalSale_diff DECIMAL(15,2);
    
    -- Jika ada perubahan quantity atau unitPrice
    IF OLD.quantity != NEW.quantity OR OLD.unitPrice != NEW.unitPrice THEN
        SET v_quantity_diff = NEW.quantity - OLD.quantity;
        SET v_totalSale_diff = NEW.totalSale - OLD.totalSale;
        
        -- Update stok berdasarkan selisih quantity
        UPDATE items 
        SET stockQuantity = stockQuantity - v_quantity_diff
        WHERE itemsId = NEW.itemsId;
        
        -- Update dailyProfitLoss
        IF v_totalSale_diff != 0 THEN
            UPDATE dailyProfitLoss
            SET 
                dailyRevenue = dailyRevenue + v_totalSale_diff,
                dailyGrossProfit = dailyRevenue - dailyCOGS
            WHERE businessId = NEW.businessId 
              AND summaryDate = DATE(NEW.outComingDate);
        END IF;
    END IF;
END $$

DELIMITER ;

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

DELIMITER $$
CREATE PROCEDURE GetTopRevenueMonths(
    IN p_businessId INT,
    IN p_year INT
)
BEGIN
    SELECT 
        RANK() OVER (ORDER BY SUM(dailyRevenue) DESC) AS ranking,
        MONTH(summaryDate) AS bulan_angka,
        DATE_FORMAT(summaryDate, '%M') AS nama_bulan,
        COUNT(*) AS hari_aktif,
        FormatRupiah(SUM(dailyRevenue)) AS total_pendapatan,
        FormatRupiah(SUM(dailyGrossProfit)) AS total_laba_kotor,
        CONCAT(FORMAT(AVG(dailyGrossProfit / NULLIF(dailyRevenue, 0)) * 100, 1), '%') AS margin_rata_rata
    FROM dailyProfitLoss
    WHERE businessId = p_businessId
      AND YEAR(summaryDate) = p_year
    GROUP BY MONTH(summaryDate), DATE_FORMAT(summaryDate, '%M')
    ORDER BY SUM(dailyRevenue) DESC;
END $$

CREATE PROCEDURE GetMonthlyRecap(
    IN p_businessId INT,
    IN p_month INT,   
    IN p_year INT       
)
BEGIN
    DECLARE v_month_name VARCHAR(20);
    DECLARE v_total_days INT;
    DECLARE v_operational_days INT;
    
    -- Get month name
    SET v_month_name = DATE_FORMAT(CONCAT(p_year, '-', p_month, '-01'), '%M');
    
    -- Calculate total days in month
    SET v_total_days = DAY(LAST_DAY(CONCAT(p_year, '-', p_month, '-01')));
    
    SELECT 
        -- Informasi Periode
        CONCAT(v_month_name, ' ', p_year) AS periode,
        p_month AS bulan_angka,
        v_month_name AS nama_bulan,
        p_year AS tahun,
        v_total_days AS total_hari_dalam_bulan,
        
        -- Statistik Hari
        COUNT(*) AS hari_operasional,
        CONCAT(FORMAT((COUNT(*) / v_total_days) * 100, 1), '%') AS persentase_operasional,
        
        -- Ringkasan Keuangan
        FormatRupiah(SUM(dailyRevenue)) AS total_pendapatan,
        FormatRupiah(SUM(dailyCOGS)) AS total_hpp,
        FormatRupiah(SUM(dailyGrossProfit)) AS total_laba_kotor,
        
        -- Rata-rata Harian
        FormatRupiah(AVG(dailyRevenue)) AS rata_rata_pendapatan_harian,
        FormatRupiah(AVG(dailyGrossProfit)) AS rata_rata_laba_harian,
        
        -- Nilai Tertinggi & Terendah
        FormatRupiah(MAX(dailyRevenue)) AS pendapatan_tertinggi,
        FormatRupiah(MIN(dailyRevenue)) AS pendapatan_terendah,
        FormatRupiah(MAX(dailyGrossProfit)) AS laba_tertinggi,
        FormatRupiah(MIN(dailyGrossProfit)) AS laba_terendah,
        
        -- Persentase
        CONCAT(FORMAT((SUM(dailyGrossProfit) / NULLIF(SUM(dailyRevenue), 0)) * 100, 1), '%') AS margin_bulanan,
        
        -- Perbandingan HPP vs Revenue
        CONCAT(FORMAT((SUM(dailyCOGS) / NULLIF(SUM(dailyRevenue), 0)) * 100, 1), '%') AS persentase_hpp
        
    FROM dailyProfitLoss
    WHERE businessId = p_businessId
      AND YEAR(summaryDate) = p_year
      AND MONTH(summaryDate) = p_month;
    
END $$

DELIMITER ; 

CREATE TABLE logs(
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
);

CREATE TABLE employeePresence (
    presenceID INT PRIMARY KEY AUTO_INCREMENT,
    userID INT NOT NULL,
    presenceDate DATE NOT NULL,
    clockIN TIME NOT NULL,
    clockOUT TIME,

    UNIQUE (userID, presenceDate),
    CHECK (clockOUT IS NULL OR clockOUT > clockIN)
);

DELIMITER $$

CREATE FUNCTION fn_total_stock(p_businessId INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT IFNULL(SUM(stockQuantity), 0)
    INTO total
    FROM items
    WHERE businessId = p_businessId;

    RETURN total;
END$$

CREATE PROCEDURE sp_dashboard_informasi_barang (
    IN p_businessId INT
)
BEGIN
    SELECT
        i.itemsId,
        i.itemName,
        i.category,
        i.stockQuantity,
        i.movingStatus,
        i.sellingPrice
    FROM items i
    WHERE i.businessId = p_businessId;
END $$

CREATE PROCEDURE sp_outcoming_item_transaction (
    IN p_businessId INT,
    IN p_itemsId INT,
    IN p_qty INT,
    IN p_userId INT
)
BEGIN
    DECLARE v_stock INT;

    START TRANSACTION;
    -- Lock data stok
    SELECT stockQuantity
    INTO v_stock
    FROM items
    WHERE itemsId = p_itemsId
      AND businessId = p_businessId
    FOR UPDATE;
    -- Item tidak ditemukan
    IF v_stock IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Item tidak ditemukan';
    END IF;
    -- Stok tidak cukup
    IF v_stock < p_qty THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stok tidak mencukupi';
    END IF;
    -- Update stok
    UPDATE items
    SET stockQuantity = stockQuantity - p_qty,
        movingStatus = 'FAST'
    WHERE itemsId = p_itemsId
      AND businessId = p_businessId;
    -- Catat barang keluar
    INSERT INTO outComingItems (
        itemsId,
        businessId,
        userId,
        quantity,
        unitPrice,
        outComingDate
    )
    VALUES (
        p_itemsId,
        p_businessId,
        p_userId,
        p_qty,
        (SELECT sellingPrice FROM items WHERE itemsId = p_itemsId),
        NOW()
    );
    COMMIT;
END$$

CREATE TRIGGER trg_check_stock_before_out
BEFORE INSERT ON outComingItems
FOR EACH ROW
BEGIN
    DECLARE currentStock INT;

    SELECT stockQuantity
    INTO currentStock
    FROM items
    WHERE itemsId = NEW.itemsId;
    IF currentStock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stok tidak mencukupi (Trigger)';
    END IF;
END $$
DELIMITER ;

-- VIEW + RANKING
-- Peringkat barang berdasarkan stok per bisnis
CREATE OR REPLACE VIEW vw_item_stock_ranking AS
SELECT
    itemsId,
    businessId,
    itemName,
    stockQuantity,
    RANK() OVER (
        PARTITION BY businessId
        ORDER BY stockQuantity DESC
    ) AS stock_rank
FROM items;

-- business 
INSERT INTO business (businessName, ownerName, businessType, address, phoneNumber) VALUES
('Toko Sembako Berkah Jaya', 'Ahmad Fauzi', 'Retail Sembako', 'Jl. Raya Pasar Minggu No. 12, Jakarta Selatan', '081234567890'),
('Kopi Nusantara', 'Dewi Lestari', 'Kedai Kopi', 'Jl. Sudirman No. 45, Bandung', '082198765432'),
('Laundry Express Clean', 'Budi Santoso', 'Jasa Laundry', 'Jl. Melati No. 8, Yogyakarta', '085712345678'),
('Percetakan Maju Mandiri', 'Rina Putri', 'Jasa Percetakan', 'Jl. Diponegoro No. 22, Surabaya', '081398765432');

-- data dummy users
INSERT INTO users (businessId, firstName, lastName, email, phone, role) VALUES
-- BUSINESS ID 1
(1, 'Ahmad', 'Fauzi', 'ahmad.owner@berkahjaya.com', '081234567101', 'owner'),
(1, 'Siti', 'Rahmawati', 'siti.akuntan@berkahjaya.com', '081234567102', 'akuntan'),
(1, 'Rudi', 'Hartono', 'rudi.gudang@berkahjaya.com', '081234567103', 'gudang'),
(1, 'Andi', 'Saputra', 'andi.sales@berkahjaya.com', '081234567104', 'sales'),

-- BUSINESS ID 2
(2, 'Dewi', 'Lestari', 'dewi.owner@kopinusantara.com', '081234567201', 'owner'),
(2, 'Rina', 'Putri', 'rina.akuntan@kopinusantara.com', '081234567202', 'akuntan'),
(2, 'Bayu', 'Pratama', 'bayu.gudang@kopinusantara.com', '081234567203', 'gudang'),
(2, 'Fajar', 'Hidayat', 'fajar.sales@kopinusantara.com', '081234567204', 'sales'),

-- BUSINESS ID 3
(3, 'Budi', 'Santoso', 'budi.owner@cleanlaundry.com', '081234567301', 'owner'),
(3, 'Lina', 'Marlina', 'lina.akuntan@cleanlaundry.com', '081234567302', 'akuntan'),
(3, 'Agus', 'Wijaya', 'agus.gudang@cleanlaundry.com', '081234567303', 'gudang'),
(3, 'Doni', 'Kurniawan', 'doni.sales@cleanlaundry.com', '081234567304', 'sales'),

-- BUSINESS ID 4
(4, 'Rina', 'Putri', 'rina.owner@majumandiri.com', '081234567401', 'owner'),
(4, 'Yuni', 'Astuti', 'yuni.akuntan@majumandiri.com', '081234567402', 'akuntan'),
(4, 'Eko', 'Susanto', 'eko.gudang@majumandiri.com', '081234567403', 'gudang'),
(4, 'Arif', 'Setiawan', 'arif.sales@majumandiri.com', '081234567404', 'sales');

-- data dummy inventaries
INSERT INTO inventaries (businessId, name, description, price, purchaseDate, status) VALUES
-- BUSINESS ID 1
(1, 'Rak Besi', 'Rak besi penyimpanan barang', 750000, CURDATE(), 'active'),
(1, 'Timbangan Digital', 'Timbangan digital 30kg', 450000, CURDATE(), 'active'),
(1, 'Meja Kasir', 'Meja kasir kayu', 1200000, CURDATE(), 'active'),
(1, 'Kursi Plastik', 'Kursi plastik pelanggan', 85000, CURDATE(), 'active'),
(1, 'Etalase Kaca', 'Etalase kaca toko', 2500000, CURDATE(), 'active'),
(1, 'Printer Struk', 'Printer struk thermal', 650000, CURDATE(), 'active'),
(1, 'Lemari Penyimpanan', 'Lemari gudang besi', 1800000, CURDATE(), 'active'),
(1, 'Kalkulator', 'Kalkulator kasir', 95000, CURDATE(), 'active'),
(1, 'Lampu LED', 'Lampu LED toko', 120000, CURDATE(), 'active'),
(1, 'Kipas Angin', 'Kipas angin berdiri', 350000, CURDATE(), 'active'),

-- BUSINESS ID 2
(2, 'Mesin Espresso', 'Mesin kopi espresso', 8500000, CURDATE(), 'active'),
(2, 'Grinder Kopi', 'Mesin penggiling kopi', 3200000, CURDATE(), 'active'),
(2, 'Meja Bar', 'Meja bar kayu', 4200000, CURDATE(), 'active'),
(2, 'Kursi Bar', 'Kursi bar besi', 650000, CURDATE(), 'active'),
(2, 'Kulkas Minuman', 'Kulkas display minuman', 3800000, CURDATE(), 'active'),
(2, 'Teko Stainless', 'Teko kopi stainless', 180000, CURDATE(), 'active'),
(2, 'Timbangan Kopi', 'Timbangan kopi digital', 350000, CURDATE(), 'active'),
(2, 'Rak Gelas', 'Rak penyimpanan gelas', 950000, CURDATE(), 'active'),
(2, 'Mesin Kasir', 'Mesin kasir POS', 2800000, CURDATE(), 'active'),
(2, 'Blender', 'Blender minuman', 650000, CURDATE(), 'active'),

-- BUSINESS ID 3
(3, 'Mesin Cuci', 'Mesin cuci kapasitas besar', 5200000, CURDATE(), 'active'),
(3, 'Mesin Pengering', 'Mesin pengering laundry', 4800000, CURDATE(), 'active'),
(3, 'Setrika Uap', 'Setrika uap laundry', 1350000, CURDATE(), 'active'),
(3, 'Meja Lipat', 'Meja lipat pakaian', 950000, CURDATE(), 'active'),
(3, 'Keranjang Laundry', 'Keranjang pakaian', 180000, CURDATE(), 'active'),
(3, 'Rak Gantungan', 'Rak gantungan baju', 1200000, CURDATE(), 'active'),
(3, 'Timbangan Laundry', 'Timbangan pakaian', 420000, CURDATE(), 'active'),
(3, 'Dispenser', 'Dispenser air', 650000, CURDATE(), 'active'),
(3, 'Kursi Tunggu', 'Kursi ruang tunggu', 750000, CURDATE(), 'active'),
(3, 'Vacuum Cleaner', 'Vacuum cleaner industri', 2100000, CURDATE(), 'active'),

-- BUSINESS ID 4
(4, 'Mesin Cetak', 'Mesin cetak offset', 12500000, CURDATE(), 'active'),
(4, 'Komputer Desain', 'PC desain grafis', 9800000, CURDATE(), 'active'),
(4, 'Printer Warna', 'Printer warna A3', 6500000, CURDATE(), 'active'),
(4, 'Meja Kerja', 'Meja kerja karyawan', 1800000, CURDATE(), 'active'),
(4, 'Kursi Kantor', 'Kursi kantor ergonomis', 2200000, CURDATE(), 'active'),
(4, 'Rak Kertas', 'Rak penyimpanan kertas', 950000, CURDATE(), 'active'),
(4, 'Mesin Laminating', 'Mesin laminating dokumen', 3200000, CURDATE(), 'active'),
(4, 'Cutter Besar', 'Mesin potong kertas', 2700000, CURDATE(), 'active'),
(4, 'Scanner', 'Scanner resolusi tinggi', 1850000, CURDATE(), 'active'),
(4, 'UPS', 'UPS komputer', 1250000, CURDATE(), 'active');


-- data dummy items
INSERT INTO items (businessId, itemName, category, purchasePrice, sellingPrice, stockQuantity, movingStatus) VALUES
-- BUSINESS ID 1 (Toko Sembako)
(1, 'Beras Premium 5kg', 'Sembako', 65000, 75000, 120, 'FAST'),
(1, 'Gula Pasir 1kg', 'Sembako', 13500, 15500, 200, 'FAST'),
(1, 'Minyak Goreng 1L', 'Sembako', 14500, 16500, 180, 'FAST'),
(1, 'Tepung Terigu 1kg', 'Sembako', 12000, 14000, 160, 'FAST'),
(1, 'Mie Instan', 'Makanan', 2500, 3500, 500, 'FAST'),
(1, 'Susu Kental Manis', 'Minuman', 9000, 11000, 90, 'SLOW'),
(1, 'Kopi Bubuk 200g', 'Minuman', 18000, 22000, 60, 'SLOW'),
(1, 'Sabun Cuci', 'Kebutuhan Rumah', 7000, 9000, 70, 'SLOW'),
(1, 'Baterai AA', 'Elektronik', 12000, 15000, 40, 'DEAD'),
(1, 'Korek Api', 'Lainnya', 2000, 3000, 150, 'FAST'),

-- BUSINESS ID 2 (Kedai Kopi)
(2, 'Biji Kopi Arabica 250g', 'Bahan Baku', 45000, 65000, 80, 'FAST'),
(2, 'Biji Kopi Robusta 250g', 'Bahan Baku', 38000, 55000, 70, 'FAST'),
(2, 'Susu Fresh 1L', 'Bahan Baku', 18000, 25000, 60, 'FAST'),
(2, 'Gula Cair', 'Bahan Baku', 12000, 18000, 50, 'SLOW'),
(2, 'Cup Kopi Panas', 'Perlengkapan', 800, 1500, 1000, 'FAST'),
(2, 'Cup Kopi Dingin', 'Perlengkapan', 900, 1700, 900, 'FAST'),
(2, 'Sedotan', 'Perlengkapan', 500, 1000, 1500, 'FAST'),
(2, 'Sirup Vanilla', 'Bahan Tambahan', 65000, 85000, 25, 'SLOW'),
(2, 'Sirup Caramel', 'Bahan Tambahan', 65000, 85000, 20, 'SLOW'),
(2, 'Chocolate Powder', 'Bahan Tambahan', 72000, 95000, 15, 'DEAD'),

-- BUSINESS ID 3 (Laundry)
(3, 'Detergen Bubuk 1kg', 'Bahan Laundry', 18000, 25000, 90, 'FAST'),
(3, 'Pewangi Laundry', 'Bahan Laundry', 22000, 30000, 70, 'FAST'),
(3, 'Plastik Laundry', 'Perlengkapan', 5000, 8000, 300, 'FAST'),
(3, 'Hanger Plastik', 'Perlengkapan', 3500, 6000, 200, 'SLOW'),
(3, 'Hanger Besi', 'Perlengkapan', 8500, 12000, 120, 'SLOW'),
(3, 'Label Nama', 'Perlengkapan', 2000, 4000, 250, 'FAST'),
(3, 'Kantong Laundry Besar', 'Perlengkapan', 12000, 18000, 60, 'SLOW'),
(3, 'Sabun Cair', 'Bahan Laundry', 25000, 35000, 40, 'SLOW'),
(3, 'Pembersih Mesin', 'Perawatan', 35000, 50000, 10, 'DEAD'),
(3, 'Sikat Laundry', 'Perlengkapan', 8000, 12000, 25, 'DEAD'),

-- BUSINESS ID 4 (Percetakan)
(4, 'Kertas A4 80gsm', 'Kertas', 45000, 60000, 200, 'FAST'),
(4, 'Kertas A3 100gsm', 'Kertas', 75000, 95000, 150, 'FAST'),
(4, 'Tinta Printer Hitam', 'Tinta', 85000, 110000, 60, 'FAST'),
(4, 'Tinta Printer Warna', 'Tinta', 95000, 125000, 55, 'FAST'),
(4, 'Cover Laminating', 'Finishing', 35000, 55000, 80, 'SLOW'),
(4, 'Spiral Jilid', 'Finishing', 15000, 25000, 120, 'SLOW'),
(4, 'Map Plastik', 'ATK', 2500, 5000, 300, 'FAST'),
(4, 'Kertas Foto', 'Kertas', 95000, 125000, 30, 'SLOW'),
(4, 'Brosur Cetak', 'Produk', 1200, 2500, 500, 'FAST'),
(4, 'Stiker Vinyl', 'Produk', 3500, 7000, 20, 'DEAD');

-- incoming items
INSERT INTO inComingItems (itemsId, businessId, userId, quantity, unitPrice, inComingDate) VALUES
-- ITEM ID 1
(1, 1, 3, 20, 65000, CURRENT_TIMESTAMP),
(1, 1, 3, 15, 64000, CURRENT_TIMESTAMP),
(1, 1, 3, 25, 65500, CURRENT_TIMESTAMP),
(1, 1, 3, 10, 66000, CURRENT_TIMESTAMP),

-- ITEM ID 2
(2, 1, 3, 30, 13500, CURRENT_TIMESTAMP),
(2, 1, 3, 25, 13800, CURRENT_TIMESTAMP),
(2, 1, 3, 20, 14000, CURRENT_TIMESTAMP),
(2, 1, 3, 15, 13700, CURRENT_TIMESTAMP),

-- ITEM ID 3
(3, 1, 3, 40, 14500, CURRENT_TIMESTAMP),
(3, 1, 3, 30, 14800, CURRENT_TIMESTAMP),
(3, 1, 3, 25, 15000, CURRENT_TIMESTAMP),
(3, 1, 3, 20, 14700, CURRENT_TIMESTAMP),

-- ITEM ID 4
(4, 1, 3, 35, 12000, CURRENT_TIMESTAMP),
(4, 1, 3, 30, 12200, CURRENT_TIMESTAMP),
(4, 1, 3, 25, 12500, CURRENT_TIMESTAMP),
(4, 1, 3, 20, 12300, CURRENT_TIMESTAMP),

-- ITEM ID 5
(5, 1, 3, 100, 2500, CURRENT_TIMESTAMP),
(5, 1, 3, 80, 2600, CURRENT_TIMESTAMP),
(5, 1, 3, 120, 2550, CURRENT_TIMESTAMP),
(5, 1, 3, 90, 2580, CURRENT_TIMESTAMP),

-- ITEM ID 6
(6, 1, 3, 25, 9000, CURRENT_TIMESTAMP),
(6, 1, 3, 20, 9200, CURRENT_TIMESTAMP),
(6, 1, 3, 15, 9500, CURRENT_TIMESTAMP),
(6, 1, 3, 10, 9400, CURRENT_TIMESTAMP),

-- ITEM ID 7
(7, 1, 3, 18, 18000, CURRENT_TIMESTAMP),
(7, 1, 3, 15, 18500, CURRENT_TIMESTAMP),
(7, 1, 3, 12, 19000, CURRENT_TIMESTAMP),
(7, 1, 3, 10, 18800, CURRENT_TIMESTAMP),

-- ITEM ID 8
(8, 1, 3, 22, 7000, CURRENT_TIMESTAMP),
(8, 1, 3, 20, 7200, CURRENT_TIMESTAMP),
(8, 1, 3, 18, 7400, CURRENT_TIMESTAMP),
(8, 1, 3, 15, 7300, CURRENT_TIMESTAMP),

-- ITEM ID 9
(9, 1, 3, 12, 12000, CURRENT_TIMESTAMP),
(9, 1, 3, 10, 12500, CURRENT_TIMESTAMP),
(9, 1, 3, 8, 13000, CURRENT_TIMESTAMP),
(9, 1, 3, 6, 12800, CURRENT_TIMESTAMP),

-- ITEM ID 10
(10, 1, 3, 50, 2000, CURRENT_TIMESTAMP),
(10, 1, 3, 45, 2100, CURRENT_TIMESTAMP),
(10, 1, 3, 40, 2200, CURRENT_TIMESTAMP),
(10, 1, 3, 35, 2150, CURRENT_TIMESTAMP),

(11, 2, 7, 50, 44000, CURRENT_TIMESTAMP),
(12, 2, 7, 50, 37000, CURRENT_TIMESTAMP),
(13, 2, 7, 40, 17500, CURRENT_TIMESTAMP),

(14, 2, 7, 30, 11500, CURRENT_TIMESTAMP),
(18, 2, 7, 20, 64000, CURRENT_TIMESTAMP),
(19, 2, 7, 15, 64000, CURRENT_TIMESTAMP),

(15, 2, 7, 500, 750, CURRENT_TIMESTAMP),
(16, 2, 7, 400, 850, CURRENT_TIMESTAMP),
(17, 2, 7, 600, 480, CURRENT_TIMESTAMP),

(20, 2, 7, 10, 70000, CURRENT_TIMESTAMP);

-- data dummy outComing Items
INSERT INTO outComingItems (itemsId, businessId, userId, quantity, unitPrice, outComingDate) VALUES
-- ITEM ID 1
(1, 1, 4, 5, 75000, CURRENT_TIMESTAMP),
(1, 1, 4, 8, 75000, CURRENT_TIMESTAMP),
(1, 1, 4, 6, 76000, CURRENT_TIMESTAMP),
(1, 1, 4, 4, 75000, CURRENT_TIMESTAMP),

-- ITEM ID 2
(2, 1, 4, 10, 15500, CURRENT_TIMESTAMP),
(2, 1, 4, 12, 15500, CURRENT_TIMESTAMP),
(2, 1, 4, 8, 16000, CURRENT_TIMESTAMP),
(2, 1, 4, 6, 15500, CURRENT_TIMESTAMP),

-- ITEM ID 3
(3, 1, 4, 15, 16500, CURRENT_TIMESTAMP),
(3, 1, 4, 12, 16500, CURRENT_TIMESTAMP),
(3, 1, 4, 10, 17000, CURRENT_TIMESTAMP),
(3, 1, 4, 8, 16500, CURRENT_TIMESTAMP),

-- ITEM ID 4
(4, 1, 4, 12, 14000, CURRENT_TIMESTAMP),
(4, 1, 4, 10, 14000, CURRENT_TIMESTAMP),
(4, 1, 4, 8, 14500, CURRENT_TIMESTAMP),
(4, 1, 4, 6, 14000, CURRENT_TIMESTAMP),

-- ITEM ID 5
(5, 1, 4, 40, 3500, CURRENT_TIMESTAMP),
(5, 1, 4, 35, 3500, CURRENT_TIMESTAMP),
(5, 1, 4, 50, 3600, CURRENT_TIMESTAMP),
(5, 1, 4, 30, 3500, CURRENT_TIMESTAMP),

-- ITEM ID 6
(6, 1, 4, 6, 11000, CURRENT_TIMESTAMP),
(6, 1, 4, 8, 11000, CURRENT_TIMESTAMP),
(6, 1, 4, 5, 11500, CURRENT_TIMESTAMP),
(6, 1, 4, 4, 11000, CURRENT_TIMESTAMP),

-- ITEM ID 7
(7, 1, 4, 5, 22000, CURRENT_TIMESTAMP),
(7, 1, 4, 6, 22000, CURRENT_TIMESTAMP),
(7, 1, 4, 4, 22500, CURRENT_TIMESTAMP),
(7, 1, 4, 3, 22000, CURRENT_TIMESTAMP),

-- ITEM ID 8
(8, 1, 4, 10, 9000, CURRENT_TIMESTAMP),
(8, 1, 4, 12, 9000, CURRENT_TIMESTAMP),
(8, 1, 4, 8, 9500, CURRENT_TIMESTAMP),
(8, 1, 4, 6, 9000, CURRENT_TIMESTAMP),

-- ITEM ID 9
(9, 1, 4, 3, 15000, CURRENT_TIMESTAMP),
(9, 1, 4, 4, 15000, CURRENT_TIMESTAMP),
(9, 1, 4, 2, 15500, CURRENT_TIMESTAMP),
(9, 1, 4, 1, 15000, CURRENT_TIMESTAMP),

-- ITEM ID 10
(10, 1, 4, 20, 3000, CURRENT_TIMESTAMP),
(10, 1, 4, 18, 3000, CURRENT_TIMESTAMP),
(10, 1, 4, 15, 3200, CURRENT_TIMESTAMP),
(10, 1, 4, 12, 3000, CURRENT_TIMESTAMP),

(11, 2, 8, 30, 67000, CURRENT_TIMESTAMP),
(12, 2, 8, 35, 56000, CURRENT_TIMESTAMP),
(13, 2, 8, 25, 26000, CURRENT_TIMESTAMP),

(15, 2, 8, 300, 1600, CURRENT_TIMESTAMP),
(16, 2, 8, 250, 1800, CURRENT_TIMESTAMP),
(17, 2, 8, 400, 1100, CURRENT_TIMESTAMP),

(14, 2, 8, 10, 19000, CURRENT_TIMESTAMP),
(18, 2, 8, 8, 88000, CURRENT_TIMESTAMP),
(19, 2, 8, 6, 88000, CURRENT_TIMESTAMP),

(20, 2, 8, 5, 98000, CURRENT_TIMESTAMP);


INSERT INTO employeePresence (userID, presenceDate, clockIN, clockOUT) VALUES
(1, '2025-01-01', '08:00:00', '17:00:00'),
(2, '2025-01-01', '08:05:00', '17:02:00'),
(3, '2025-01-01', '07:58:00', '16:55:00'),
(4, '2025-01-01', '08:10:00', '17:15:00'),
(5, '2025-01-01', '08:02:00', '17:00:00'),

(6, '2025-01-02', '08:00:00', '17:00:00'),
(7, '2025-01-02', '08:07:00', '17:10:00'),
(8, '2025-01-02', '07:55:00', '16:50:00'),
(9, '2025-01-02', '08:12:00', '17:20:00'),
(10,'2025-01-02', '08:01:00', '17:00:00'),

(1, '2025-01-03', '08:03:00', '17:05:00'),
(2, '2025-01-03', '08:00:00', '17:00:00'),
(3, '2025-01-03', '08:06:00', '17:10:00'),
(4, '2025-01-03', '08:15:00', '17:25:00'),
(5, '2025-01-03', '07:59:00', '16:58:00'),

(6, '2025-01-04', '08:02:00', '17:00:00'),
(7, '2025-01-04', '08:00:00', '17:00:00'),
(8, '2025-01-04', '08:05:00', '17:10:00'),
(9, '2025-01-04', '08:08:00', '17:12:00'),
(10,'2025-01-04', '07:57:00', '16:55:00'),

(1, '2025-01-05', '08:00:00', '17:00:00'),
(2, '2025-01-05', '08:04:00', '17:05:00'),
(3, '2025-01-05', '08:10:00', '17:15:00'),
(4, '2025-01-05', '08:20:00', '17:30:00'),
(5, '2025-01-05', '07:56:00', '16:50:00'),

(6, '2025-01-06', '08:01:00', '17:00:00'),
(7, '2025-01-06', '08:03:00', '17:05:00'),
(8, '2025-01-06', '08:00:00', '17:00:00'),
(9, '2025-01-06', '08:09:00', '17:18:00'),
(10,'2025-01-06', '08:02:00', '17:05:00');