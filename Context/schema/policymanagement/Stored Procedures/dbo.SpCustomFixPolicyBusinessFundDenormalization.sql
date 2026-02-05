SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.SpCustomFixPolicyBusinessFundDenormalization @BatchSize INT = 11000000, @Debug int = 0 -- negative debug will only output messages and will not change anything, non zero will producde debug output, -2 will change and rollback
AS

SET NOCOUNT ON
DECLARE @duration int, @now datetime = getdate(), @rows int, @TotalRows int=0
, @MinPolicyBusinessFundId int, @MaxPolicyBusinessFundId int, @topPolicyBusinessFundId int

DROP TABLE IF EXISTS #PolicyBusinessFundIds
CREATE TABLE #PolicyBusinessFundIds (PolicyBusinessFundId int)

SELECT @MinPolicyBusinessFundId=min(PolicyBusinessFundId), @MaxPolicyBusinessFundId=max(PolicyBusinessFundId) from PolicyManagement..TPolicyBusinessFund
SET @topPolicyBusinessFundId = @MinPolicyBusinessFundId + @BatchSize

WHILE @MinPolicyBusinessFundId <= @MaxPolicyBusinessFundId
BEGIN

/*
TPolicyBusinessFund.FundId can join to several different tables, like this:

If PolicyBusinessFund.FromFeedFg = 1 and PolicyBusinessFund.EquityFg = 0 then
PolicyBusinessFund.FundId = Fund2..TFundUnit.FundUnitId
If PolicyBusinessFund.FromFeedFg = 1 and PolicyBusinessFund.EquityFg = 1 then
PolicyBusinessFund.FundId = Fund2..TEquity.EquityId
If PolicyBusinessFund.FromFeedFg = 0  then
PolicyBusinessFund.FundId = TNonFeedFund.NonFeedFundId
*/

    INSERT #PolicyBusinessFundIds
    SELECT DISTINCT PolicyBusinessFundId
    FROM PolicyManagement..TPolicyBusinessFund a
    LEFT JOIN Fund2..TFundUnit b on a.FundId = b.FundUnitId and a.FromFeedFg = 1 AND a.EquityFg = 0
    LEFT JOIN Fund2..TFund c on b.FundId = c.FundId
    LEFT JOIN Fund2..TFundSector d on c.FundSectorId = d.FundSectorId
    LEFT JOIN Fund2..TEquity e on a.FundId = e.EquityId AND a.EquityFg = 1

    WHERE 
        PolicyBusinessFundId BETWEEN @MinPolicyBusinessFundId AND @topPolicyBusinessFundId
    AND
    ( a.EquityFg = 0 AND (a.FundName <> b.UnitLongName OR a.CategoryName <> d.FundSectorName )
    OR a.EquityFg = 1 AND a.FundName <> e.EquityName
    )

    SELECT @rows = @@ROWCOUNT, @duration= datediff(s,@now, getdate()), @Now=GETDATE()
    IF ABS(@Debug)>0 RAISERROR ('@topPolicyBusinessFundId=%d; INSERT #PolicyBusinessFundIds: @rows=%d, @duration=%d', 0,0, @topPolicyBusinessFundId, @rows, @duration) WITH NOWAIT
    SET @TotalRows += @rows;
    SELECT @MinPolicyBusinessFundId=@topPolicyBusinessFundId, @topPolicyBusinessFundId+=@BatchSize
END
IF ABS(@Debug)>0 RAISERROR ('Total #PolicyBusinessFundIds rows=%d',0,0,@TotalRows) WITH NOWAIT

IF @TotalRows > 0 AND @Debug >-2
BEGIN
    BEGIN TRAN
    -- Fix Fund Name
        INSERT PolicyManagement..TPolicyBusinessFundAudit
        (PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName, CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice,
            LastPriceChangeDate, PriceUpdatedByUser, FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating, EquityFg, ConcurrencyId,
            PolicyBusinessFundId, StampAction, StampDateTime, StampUser, Cost, LastTransactionChangeDate, 
            RegularContributionPercentage, UpdatedByReplicatedProc)
        SELECT PolicyBusinessId, a.FundId, FundTypeId, FundName, CategoryId, CategoryName, CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice,
            LastPriceChangeDate, PriceUpdatedByUser, FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating, EquityFg, a.ConcurrencyId,
            a.PolicyBusinessFundId, 'U', getdate(), 0, Cost, LastTransactionChangeDate, 
            RegularContributionPercentage, UpdatedByReplicatedProc
        FROM PolicyManagement..TPolicyBusinessFund a 
        JOIN #PolicyBusinessFundIds b on a.PolicyBusinessFundId = b.PolicyBusinessFundId
        JOIN Fund2..TFundUnit fu  on a.FundId = fu.FundUnitId and a.FromFeedFg = 1 and EquityFg = 0
        WHERE a.FundName <> fu.UnitLongName

        SELECT @rows = @@ROWCOUNT, @duration= datediff(s,@now, getdate()), @Now=GETDATE()
        IF ABS(@Debug)>0 RAISERROR ('Insert Into TPolicyBusinessFundAudit: @rows=%d, @duration=%d', 0,0, @rows, @duration) WITH NOWAIT

        UPDATE A
        SET a.FundName = b.UnitLongName, a.CategoryName = d.FundSectorName
        FROM PolicyManagement..TPolicyBusinessFund a 
        JOIN Fund2..TFundUnit b  on a.FundId = b.FundUnitId and a.FromFeedFg = 1 and EquityFg = 0
        JOIN Fund2..TFund c  on b.FundId = c.FundId
        JOIN Fund2..TFundSector d  on c.FundSectorId = d.FundSectorId
        JOIN #PolicyBusinessFundIds e on a.PolicyBusinessFundId = e.PolicyBusinessFundId
        WHERE a.FundName <> b.UnitLongName

    SELECT @rows = @@ROWCOUNT, @duration= datediff(s,@now, getdate()), @Now=GETDATE()
    IF ABS(@Debug)>0 RAISERROR ('Update TPolicyBusinessFund : @rows=%d, @duration=%d', 0,0, @rows, @duration) WITH NOWAIT

    IF @Debug >-1 
        COMMIT 
    ELSE ROLLBACK

    -- Fix Fund Category
    BEGIN TRAN
    Print GetDate()

        INSERT Into PolicyManagement..TPolicyBusinessFundAudit
        (PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName, CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice,
        LastPriceChangeDate, PriceUpdatedByUser, FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating, EquityFg, ConcurrencyId,
        PolicyBusinessFundId, StampAction, StampDateTime, StampUser, Cost, LastTransactionChangeDate, 
        RegularContributionPercentage, UpdatedByReplicatedProc)
        SELECT PolicyBusinessId, a.FundId, FundTypeId, FundName, CategoryId, CategoryName, CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice,
        LastPriceChangeDate, PriceUpdatedByUser, FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating, EquityFg, a.ConcurrencyId,
        a.PolicyBusinessFundId, 'U', getdate(), 0, Cost, LastTransactionChangeDate, 
            RegularContributionPercentage, UpdatedByReplicatedProc
        FROM PolicyManagement..TPolicyBusinessFund a 
        JOIN #PolicyBusinessFundIds fu on a.PolicyBusinessFundId = fu.PolicyBusinessFundId
        JOIN Fund2..TFundUnit b ON a.FundId = b.FundUnitId and a.FromFeedFg = 1 and EquityFg = 0
        JOIN Fund2..TFund c ON b.FundId = c.FundId
        JOIN Fund2..TFundSector d  ON c.FundSectorId = d.FundSectorId
        WHERE  a.CategoryName <> d.FundSectorName and EquityFg = 0

        SELECT @rows = @@ROWCOUNT, @duration= datediff(s,@now, getdate()), @Now=GETDATE()
        IF ABS(@Debug)>0 RAISERROR ('Fix Fund Category INSERT TPolicyBusinessFundAudit: @rows=%d, @duration=%d', 0,0, @rows, @duration) WITH NOWAIT

        UPDATE A
        SET  a.CategoryName = d.FundSectorName
        FROM PolicyManagement..TPolicyBusinessFund a 
        JOIN Fund2..TFundUnit b  ON a.FundId = b.FundUnitId and a.FromFeedFg = 1 and EquityFg = 0
        JOIN Fund2..TFund c  ON b.FundId = c.FundId
        JOIN Fund2..TFundSector d  ON c.FundSectorId = d.FundSectorId
        JOIN #PolicyBusinessFundIds fu ON a.PolicyBusinessFundId = fu.PolicyBusinessFundId
        WHERE  a.CategoryName <> d.FundSectorName and EquityFg = 0

        SELECT @rows = @@ROWCOUNT, @duration= datediff(s,@now, getdate()), @Now=GETDATE()
        IF ABS(@Debug)>0 RAISERROR ('Fix Fund Category  UPDATE TPolicyBusinessFund : @rows=%d, @duration=%d', 0,0, @rows, @duration) WITH NOWAIT
            
        IF @Debug >-1 
            COMMIT 
        ELSE ROLLBACK

-- Fix Equity Name
    BEGIN TRAN
        Print GetDate()

        INSERT Into PolicyManagement..TPolicyBusinessFundAudit
        (PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName, CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice,
            LastPriceChangeDate, PriceUPDATEdByUser, FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating, EquityFg, ConcurrencyId,
            PolicyBusinessFundId, StampAction, StampDateTime, StampUser, Cost, LastTransactionChangeDate, 
            RegularContributionPercentage, UPDATEdByReplicatedProc)
        SELECT PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName, CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice,
            LastPriceChangeDate, PriceUPDATEdByUser, FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating, EquityFg, a.ConcurrencyId,
            a.PolicyBusinessFundId, 'U', getdate(), 0, Cost, LastTransactionChangeDate, 
            RegularContributionPercentage, UPDATEdByReplicatedProc
        FROM PolicyManagement..TPolicyBusinessFund a 
        JOIN #PolicyBusinessFundIds b ON a.PolicyBusinessFundId = b.PolicyBusinessFundId

        INNER Join Fund2..TEquity e on a.FundId = e.EquityId AND a.FromFeedFg = 1
        WHERE a.EquityFg = 1 AND a.FundName <> e.EquityName

        SELECT @rows = @@ROWCOUNT, @duration= datediff(s,@now, getdate()), @Now=GETDATE()
        IF ABS(@Debug)>0 RAISERROR ('Fix Equity Name@topPolicyBusinessFundId INSERT @TPolicyBusinessFundAudit : @rows=%d, @duration=%d', 0,0, @rows, @duration) WITH NOWAIT
	
	UPDATE A
        SET  a.FundName = b.EquityName
        FROM PolicyManagement..TPolicyBusinessFund a 
        JOIN Fund2..TEquity b  ON a.FundId = b.EquityId and a.FromFeedFg = 1
	JOIN #PolicyBusinessFundIds fu ON a.PolicyBusinessFundId = fu.PolicyBusinessFundId
	WHERE a.EquityFg = 1 AND a.FundName <> b.EquityName

        SELECT @rows = @@ROWCOUNT, @duration= datediff(s,@now, getdate()), @Now=GETDATE()
        IF ABS(@Debug)>0 RAISERROR ('Fix Equity Name@topPolicyBusinessFundId Update TPolicyBusinessFund : @rows=%d, @duration=%d', 0,0, @rows, @duration) WITH NOWAIT
	IF @Debug >-1 
        COMMIT 
    ELSE ROLLBACK
END
-- Fix NonFeedFund Name and Category Name
TRUNCATE TABLE #PolicyBusinessFundIds;

INSERT #PolicyBusinessFundIds
SELECT PolicyBusinessFundId
FROM PolicyManagement..TPolicyBusinessFund a
JOIN PolicyManagement..TNonFeedFund b ON a.FundId = b.NonFeedFundId and a.FromFeedFg = 0 
WHERE a.FundName <> b.FundName OR a.CategoryName <> b.CategoryName
    
SELECT @rows = @@ROWCOUNT, @duration= datediff(s,@now, getdate()), @Now=GETDATE()
IF ABS(@Debug)>0 RAISERROR ('Fix NonFeedFund@topPolicyBusinessFundId INSERT @PolicyBusinessFundIds : @rows=%d, @duration=%d', 0,0, @rows, @duration) WITH NOWAIT

If @Rows > 0 AND @Debug >-2
BEGIN
    BEGIN TRAN
        PRINT GetDate()

        INSERT Into PolicyManagement..TPolicyBusinessFundAudit
        (PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName, CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice,
            LastPriceChangeDate, PriceUPDATEdByUser, FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating, EquityFg, ConcurrencyId,
            PolicyBusinessFundId, StampAction, StampDateTime, StampUser, Cost, LastTransactionChangeDate, 
            RegularContributionPercentage, UPDATEdByReplicatedProc)
        SELECT PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName, CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice,
            LastPriceChangeDate, PriceUPDATEdByUser, FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating, EquityFg, ConcurrencyId,
            a.PolicyBusinessFundId, 'U', getdate(), 0, Cost, LastTransactionChangeDate, 
            RegularContributionPercentage, UPDATEdByReplicatedProc
        FROM PolicyManagement..TPolicyBusinessFund a 
        JOIN #PolicyBusinessFundIds b ON a.PolicyBusinessFundId = b.PolicyBusinessFundId

        SELECT @rows = @@ROWCOUNT, @duration= datediff(s,@now, getdate()), @Now=GETDATE()
        IF ABS(@Debug)>0 RAISERROR ('Fix NonFeedFund@topPolicyBusinessFundId INSERT TPolicyBusinessFundAudit : @rows=%d, @duration=%d', 0,0, @rows, @duration) WITH NOWAIT

        UPDATE A
        SET  a.FundName = b.FundName, a.CategoryName = b.CategoryName
        FROM PolicyManagement..TPolicyBusinessFund a 
        JOIN PolicyManagement..TNonFeedFund b  ON a.FundId = b.NonFeedFundId and a.FromFeedFg = 0 
        JOIN #PolicyBusinessFundIds e ON a.PolicyBusinessFundId = e.PolicyBusinessFundId

        SELECT @rows = @@ROWCOUNT, @duration= datediff(s,@now, getdate()), @Now=GETDATE()
        IF ABS(@Debug)>0 RAISERROR ('Fix NonFeedFund@topPolicyBusinessFundId UPDATE TPolicyBusinessFund : @rows=%d, @duration=%d', 0,0, @rows, @duration) WITH NOWAIT

    IF @Debug >-1 
        COMMIT 
    ELSE ROLLBACK
END
GO