-- Trigger Update Stok Saat Barang Masuk
CREATE TRIGGER UpdateStockAfterIncoming
AFTER INSERT ON inComingItems
FOR EACH ROW
BEGIN
    -- Update stok di tabel items
    UPDATE items 
    SET stockQuantity = stockQuantity + NEW.quantity
    WHERE itemsId = NEW.itemsId;
END

-- trigger untuk mengkalkulasi profit harian 
CREATE TRIGGER trg_after_incomingitems_insert
AFTER INSERT ON inComingItems
FOR EACH ROW
BEGIN
    DECLARE v_summaryDate DATE;

    -- Ambil tanggal transaksi
    SET v_summaryDate = DATE(NEW.inComingDate);

    -- Jika data harian sudah ada → UPDATE
    IF EXISTS (
        SELECT 1 
        FROM dailyProfitLoss 
        WHERE businessId = NEW.businessId 
          AND summaryDate = v_summaryDate
    ) THEN

        UPDATE dailyProfitLoss
        SET 
            dailyCOGS = dailyCOGS + NEW.totalPurchase,
            dailyGrossProfit = dailyRevenue - (dailyCOGS + NEW.totalPurchase)
        WHERE businessId = NEW.businessId
          AND summaryDate = v_summaryDate;

    -- Jika belum ada → INSERT
    ELSE

        INSERT INTO dailyProfitLoss (
            businessId,
            summaryDate,
            dailyRevenue,
            dailyCOGS,
            dailyGrossProfit
        ) VALUES (
            NEW.businessId,
            v_summaryDate,
            0,
            NEW.totalPurchase,
            0 - NEW.totalPurchase
        );

    END IF;
END