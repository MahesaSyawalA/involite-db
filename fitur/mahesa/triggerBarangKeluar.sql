-- Trigger Update Stok Saat Barang Keluar
CREATE TRIGGER UpdateStockAfterOutgoing
AFTER INSERT ON outComingItems
FOR EACH ROW
BEGIN
    -- Update stok di tabel items (dikurangi)
    UPDATE items 
    SET stockQuantity = stockQuantity - NEW.quantity
    WHERE itemsId = NEW.itemsId;
END

-- Trigger untuk mengkalkulasi profit harian dari penjualan
CREATE TRIGGER trg_after_outcomingitems_insert
AFTER INSERT ON outComingItems
FOR EACH ROW
BEGIN
    DECLARE v_summaryDate DATE;
    DECLARE v_totalSale DECIMAL(15,2);
    
    -- Ambil tanggal transaksi
    SET v_summaryDate = DATE(NEW.outComingDate);
    
    -- Gunakan nilai totalSale yang sudah di-generate
    SET v_totalSale = NEW.totalSale;
    
    -- Jika data harian sudah ada → UPDATE
    IF EXISTS (
        SELECT 1 
        FROM dailyProfitLoss 
        WHERE businessId = NEW.businessId 
          AND summaryDate = v_summaryDate
    ) THEN
    
        UPDATE dailyProfitLoss
        SET 
            dailyRevenue = dailyRevenue + v_totalSale,
            dailyGrossProfit = (dailyRevenue + v_totalSale) - dailyCOGS
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
            v_totalSale,
            0,
            v_totalSale  -- Gross Profit = Revenue - COGS (0)
        );
    
    END IF;
END

-- Trigger untuk rollback stok jika data outComingItems dihapus
CREATE TRIGGER RestoreStockAfterOutgoingDelete
AFTER DELETE ON outComingItems
FOR EACH ROW
BEGIN
    -- Kembalikan stok ke jumlah semula
    UPDATE items 
    SET stockQuantity = stockQuantity + OLD.quantity
    WHERE itemsId = OLD.itemsId;
END

-- Trigger untuk update profit harian jika data outComingItems dihapus
CREATE TRIGGER trg_after_outcomingitems_delete
AFTER DELETE ON outComingItems
FOR EACH ROW
BEGIN
    DECLARE v_summaryDate DATE;
    DECLARE v_totalSale DECIMAL(15,2);
    
    -- Ambil tanggal transaksi lama
    SET v_summaryDate = DATE(OLD.outComingDate);
    SET v_totalSale = OLD.totalSale;
    
    -- Update dailyProfitLoss dengan mengurangi revenue
    IF EXISTS (
        SELECT 1 
        FROM dailyProfitLoss 
        WHERE businessId = OLD.businessId 
          AND summaryDate = v_summaryDate
    ) THEN
    
        UPDATE dailyProfitLoss
        SET 
            dailyRevenue = dailyRevenue - v_totalSale,
            dailyGrossProfit = (dailyRevenue - v_totalSale) - dailyCOGS
        WHERE businessId = OLD.businessId
          AND summaryDate = v_summaryDate;
    
    END IF;
END