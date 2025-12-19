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
