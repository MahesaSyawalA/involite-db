-- create table outComingItems atau penjualan
CREATE TABLE outComingItems (
    ociId INT AUTO_INCREMENT PRIMARY KEY,

    itemsId INT NOT NULL,
    businessId INT NOT NULL,
    userId INT NOT NULL,

    quantity INT NOT NULL,
    unitPrice INT NOT NULL,

    totalSale INT GENERATED ALWAYS AS (quantity * unitPrice) STORED,

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

-- insert 50 data dummy 
INSERT INTO outComingItems (itemsId, businessId, userId, quantity, unitPrice, outComingDate) VALUES
(1, 1, 1, 2, 10000, '2025-01-01 10:00:00'),
(2, 1, 2, 1, 15000, '2025-01-01 11:00:00'),
(3, 1, 3, 5, 7000,  '2025-01-02 09:30:00'),
(4, 2, 1, 3, 12000, '2025-01-02 13:00:00'),
(5, 2, 2, 4, 9000,  '2025-01-03 14:00:00'),
(6, 2, 3, 2, 20000, '2025-01-03 15:30:00'),
(7, 3, 4, 6, 8000,  '2025-01-04 10:45:00'),
(8, 3, 5, 1, 30000, '2025-01-04 11:15:00'),
(9, 1, 1, 7, 5000,  '2025-01-05 09:00:00'),
(10,1, 2, 2, 25000, '2025-01-05 16:00:00'),

(1, 2, 3, 4, 10000, '2025-01-06 10:00:00'),
(2, 2, 4, 3, 15000, '2025-01-06 11:30:00'),
(3, 3, 5, 6, 7000,  '2025-01-07 12:00:00'),
(4, 3, 1, 1, 12000, '2025-01-07 14:00:00'),
(5, 1, 2, 5, 9000,  '2025-01-08 15:00:00'),
(6, 1, 3, 2, 20000, '2025-01-08 16:00:00'),
(7, 2, 4, 3, 8000,  '2025-01-09 09:00:00'),
(8, 2, 5, 1, 30000, '2025-01-09 10:00:00'),
(9, 3, 1, 8, 5000,  '2025-01-10 11:00:00'),
(10,3, 2, 2, 25000, '2025-01-10 13:00:00'),

(1, 1, 3, 6, 10000, '2025-01-11 10:00:00'),
(2, 1, 4, 4, 15000, '2025-01-11 11:30:00'),
(3, 1, 5, 3, 7000,  '2025-01-12 09:30:00'),
(4, 2, 1, 2, 12000, '2025-01-12 14:00:00'),
(5, 2, 2, 7, 9000,  '2025-01-13 15:00:00'),
(6, 2, 3, 1, 20000, '2025-01-13 16:00:00'),
(7, 3, 4, 5, 8000,  '2025-01-14 10:00:00'),
(8, 3, 5, 2, 30000, '2025-01-14 11:00:00'),
(9, 1, 1, 9, 5000,  '2025-01-15 12:00:00'),
(10,1, 2, 3, 25000, '2025-01-15 14:00:00'),

(1, 2, 3, 2, 10000, '2025-01-16 10:00:00'),
(2, 2, 4, 5, 15000, '2025-01-16 11:00:00'),
(3, 3, 5, 4, 7000,  '2025-01-17 09:30:00'),
(4, 3, 1, 6, 12000, '2025-01-17 13:00:00'),
(5, 1, 2, 3, 9000,  '2025-01-18 15:00:00'),
(6, 1, 3, 2, 20000, '2025-01-18 16:00:00'),
(7, 2, 4, 7, 8000,  '2025-01-19 10:00:00'),
(8, 2, 5, 1, 30000, '2025-01-19 11:00:00'),
(9, 3, 1, 4, 5000,  '2025-01-20 12:00:00'),
(10,3, 2, 2, 25000, '2025-01-20 14:00:00');
