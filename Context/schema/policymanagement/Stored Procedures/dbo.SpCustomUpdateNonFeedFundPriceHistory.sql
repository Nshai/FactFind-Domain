SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomUpdateNonFeedFundPriceHistory]
	@Today DATE,
	@TwentyFourHoursAgoInUtc DATETIME
AS
-----------------------------------------------------------
-- Find all price data that has changed today
-----------------------------------------------------------
SELECT
	NonFeedFundId,
	CurrentPrice AS [Price],
	CAST([PriceDate] as date) AS [PriceDate]
INTO
	#DailyFundPrices
FROM
	TNonFeedFund NFF WITH(NOLOCK)
WHERE
	CAST(NFF.PriceDate AS date) = @Today
	AND CurrentPrice IS NOT NULL
	AND PriceDate IS NOT NULL

-----------------------------------------------------------
-- Delete any records if we've already got the price
-----------------------------------------------------------
DELETE A
FROM 
	#DailyFundPrices A
	JOIN TNonFeedFundPriceHistory B ON B.NonFeedFundId = A.NonFeedFundId AND A.PriceDate = B.PriceDate

-----------------------------------------------------------
-- Add new price data
-----------------------------------------------------------
INSERT INTO TNonFeedFundPriceHistory(NonFeedFundId, Price, PriceDate)
SELECT NonFeedFundId, Price, [PriceDate]
FROM #DailyFundPrices

-----------------------------------------------------------
-- See if we can find any more data from the audit table
-----------------------------------------------------------
SELECT
	NonFeedFundId,
	MAX(CurrentPrice) AS [Price],
	CAST([PriceDate] as date) AS [PriceDate]
INTO
	#AuditFundPrices
FROM
	TNonFeedFundAudit NFF WITH(NOLOCK)
WHERE
	StampDateTime > @TwentyFourHoursAgoInUtc
	AND CurrentPrice IS NOT NULL
	AND PriceDate IS NOT NULL
GROUP BY
	NonFeedFundId, CAST([PriceDate] as date)

-----------------------------------------------------------
-- Delete any records if we've already got the price
-----------------------------------------------------------
DELETE A
FROM 
	#AuditFundPrices A
	JOIN TNonFeedFundPriceHistory B ON B.NonFeedFundId = A.NonFeedFundId AND A.PriceDate = B.PriceDate

-----------------------------------------------------------
-- Add new price data
-----------------------------------------------------------
INSERT INTO TNonFeedFundPriceHistory(NonFeedFundId, Price, PriceDate)
SELECT NonFeedFundId, Price, [PriceDate]
FROM #AuditFundPrices
GO
