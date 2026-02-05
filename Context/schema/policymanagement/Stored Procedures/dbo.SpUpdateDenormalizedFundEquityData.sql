SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpUpdateDenormalizedFundEquityData]

as 

set transaction isolation level read uncommitted
SET QUOTED_IDENTIFIER ON

DECLARE @RegionalCurrency VARCHAR(3)

IF OBJECT_ID('tempdb..#TmpNewFund') IS NOT NULL
	DROP TABLE #TmpNewFund
IF OBJECT_ID('tempdb..#TmpNewEquity') IS NOT NULL
	DROP TABLE #TmpNewEquity
IF OBJECT_ID('tempdb..#TmpFundToUpdate') IS NOT NULL
	DROP TABLE #TmpFundToUpdate
IF OBJECT_ID('tempdb..#TmpEquityToUpdate') IS NOT NULL
	DROP TABLE #TmpFundToUpdate
IF OBJECT_ID('tempdb..#TmpExRate') IS NOT NULL
	DROP TABLE #TmpExRate

CREATE TABLE #TmpNewFund(
	FundUnitId bigint primary key, 
	fundId int, 
	fundTypeId int, 
	fundTypeName varchar(255),
	Name varchar(255), 
	SedolCode varchar(50), 
	MexCode varchar(50),
	ISINCode varchar(50), 
	CitiCode varchar(50), 
	FundSectorId int,
	FundSectorName varchar(255),
	CurrentPrice money, 
	PriceDate datetime,
	Currency varchar(50),
	UpdatedFg bit,
	APIRCode varchar(50),
	Source varchar(50),
	TickerCode varchar(50),
	FeedFundCode varchar(50))

CREATE TABLE #TmpNewEquity(
	EquityId bigint primary key, 
	Name varchar(255),
	EpicCode varchar(50), 
	ISINCode varchar(50), 
	UpdatedFg bit, 
	CurrentPrice money, 
	PriceDate datetime,
	Currency varchar(50))

CREATE TABLE #TmpFundToUpdate(
	FundUnitId bigint primary key, 
	fundTypeId int, 
	fundTypeName varchar(255), 
	Name varchar(255), 
	SedolCode varchar(50), 
	MexCode varchar(50),
	ISINCode varchar(50), 
	CitiCode varchar(50), 
	FundSectorId int, 
	FundSectorName varchar(255), 
	CurrentPrice money, 
	PriceDate datetime,
	Currency varchar(50),
	UpdatedFg bit,
	APIRCode varchar(50),
	Source varchar(50),
	TickerCode varchar(50),
	FeedFundCode varchar(50))

CREATE TABLE #TmpEquityToUpdate(
	EquityId bigint primary key, 
	Name varchar(255), 
	EpicCode varchar(50), 
	ISINCode varchar(50), 
	UpdatedFg bit, 
	CurrentPrice money, 
	PriceDate datetime,
	Currency varchar(50))

CREATE TABLE #TmpExRate
(
	 SourceCurrency	VARCHAR(3) PRIMARY KEY
	,ExRate			DECIMAL(18,10)
)

-- cache the exchange rates
;WITH cteCurrencies AS
(
	SELECT DISTINCT fu.Currency	AS SourceCurrency
	FROM fund2.dbo.TFundUnit fu
	UNION SELECT DISTINCT eq.Currency AS SourceCurrency
	FROM fund2.dbo.TEquity eq
)
INSERT INTO #TmpExRate
SELECT 
	 SourceCurrency,
	 dbo.FnGetCurrencyRate(SourceCurrency, '')
FROM 
	cteCurrencies

--add new funds
INSERT INTO #TmpNewFund
SELECT 
	fu.FundUnitId, 
	fu.FundId, 
	f.RefFundTypeId, 
	rft.FundTypeName, 
	fu.UnitLongName, 
	fu.SedolCode, 
	fu.MexCode, 
	fu.ISINCode, 
	fu.CitiCode,
	f.FundSectorId, 
	fs.FundSectorName,
	ROUND(CASE
			WHEN ISNULL(fup.MidPrice, 0) > 0 THEN fup.MidPrice
			WHEN ISNULL(fup.BidPrice, 0) > 0 THEN fup.BidPrice
			ELSE fup.OfferPrice
		  END * ISNULL(cr.ExRate, 1.0), 4),
	fup.PriceDate,
	fu.Currency,
	fu.UpdatedFg,
	fu.APIRCode,
	CASE
		WHEN f.Source IS NULL THEN 'FinExFeed'
		ELSE f.Source
	END,
	fu.TickerCode,
	fu.FeedFundCode
FROM 
	fund2..TFundUnit fu
	JOIN Fund2..tfund f ON fu.FundId = f.FundId
	JOIN Fund2..TFundUnitPrice fup ON fu.FundUnitId = fup.FundUnitId
	JOIN Fund2..TRefFundType rft ON f.RefFundTypeId = rft.RefFundTypeId
	JOIN Fund2..TFundSector fs ON fs.FundSectorId = f.FundSectorId
	LEFT JOIN #TmpExRate cr ON cr.SourceCurrency = fu.currency 
	LEFT OUTER JOIN TFundDenorm fd ON fd.FundUnitId = fu.FundUnitId
WHERE 
	fd.FundUnitId IS NULL

--update funds
INSERT INTO #TmpFundToUpdate
SELECT 
	fu.FundUnitId, 
	f.RefFundTypeId, 
	rft.FundTypeName, 
	fu.UnitLongName, 
	fu.SedolCode, 
	fu.MexCode, 
	fu.ISINCode, 
	fu.CitiCode,
	f.FundSectorId, 
	fs.FundSectorName,
	ROUND(CASE 
			WHEN ISNULL(fup.MidPrice,0) > 0 THEN fup.MidPrice
			WHEN ISNULL(fup.BidPrice,0) > 0 THEN fup.BidPrice
			ELSE fup.OfferPrice
		  END * ISNULL(cr.ExRate, 1.0), 4), 
	fup.PriceDate,
	fu.Currency,
	fu.UpdatedFg,
	fu.APIRCode,
	CASE
		WHEN f.Source IS NULL THEN 'FinExFeed'
		ELSE f.Source
	END,
	fu.TickerCode,
	fu.FeedFundCode
FROM 
	fund2..TFundUnit fu
	JOIN Fund2..tfund f ON fu.FundId = f.FundId
	JOIN Fund2..TRefFundType rft ON f.RefFundTypeId = rft.RefFundTypeId
	JOIN Fund2..TFundSector fs ON fs.FundSectorId = f.FundSectorId
	JOIN TFundDenorm fd ON fd.FundUnitId = fu.FundUnitId
	JOIN Fund2..TFundUnitPrice fup ON fu.FundUnitId = fup.FundUnitId
	LEFT JOIN #TmpExRate cr ON cr.SourceCurrency = fu.currency 
WHERE 
	(fd.FundTypeId <> f.RefFundTypeId 
	OR IsNull(fd.FundTypeName,'') <> IsNull(rft.FundTypeName,'') 
	OR IsNull(fd.Name,'') <> IsNull(fu.UnitLongName,'') 
	OR IsNull(fd.SedolCode,'') <> IsNull(fu.SedolCode,'') 
	OR IsNull(fd.MexCode,'') <> IsNull(fu.MexCode,'') 
	OR IsNull(fd.ISINCode,'') <> IsNull(fu.ISINCode,'') 
	OR IsNull(fd.Citicode,'') <> IsNull(fu.CitiCode,'')
	OR IsNull(fd.FeedFundCode,'') <> IsNull(fu.FeedFundCode,'')
	OR IsNull(fd.FundSectorId,'') <> IsNull(f.FundSectorId,'') 
	OR IsNull(fd.FundSectorName,'') <> IsNull(fs.FundSectorName,'')
	OR IsNull(fd.Currency,'') <> IsNull(fu.Currency,'')
	OR fd.UpdatedFg <> fu.UpdatedFg)

UPDATE fd
SET fd.FundTypeId = tuf.FundTypeId, 
	fd.FundTypeName = tuf.FundTypeName, 
	fd.Name = tuf.Name, 
	fd.SedolCode = tuf.SedolCode, 
	fd.MexCode = tuf.MexCode, 
	fd.ISINCode = tuf.ISINCode, 
	fd.Citicode = tuf.CitiCode,
	fd.FundSectorId = tuf.FundSectorId, 
	fd.FundSectorName = tuf.FundSectorName,
	fd.Currency = tuf.Currency,
	fd.UpdatedFg = tuf.UpdatedFg,
	fd.APIRCode = tuf.APIRCode,
	fd.Source = tuf.Source,
	fd.TickerCode =  tuf.TickerCode,
	fd.FeedFundCode = tuf.FeedFundCode
FROM 
	TFundDenorm fd
	INNER JOIN #TmpFundToUpdate tuf 
		ON tuf.FundUnitId = fd.FundUnitId

INSERT INTO TFundDenorm
Select  tnf.FundId, 
		tnf.FundUnitId, 
		tnf.FundTypeId, 
		tnf.FundTypeName, 
		tnf.Name, 
		tnf.SedolCode, 
		tnf.MexCode, 
		tnf.ISINCode, 
		tnf.CitiCode,
		tnf.FundSectorId, 
		tnf.FundSectorName,
		tnf.Currency,
		tnf.UpdatedFg,
		tnf.APIRCode,
		tnf.Source,
		tnf.TickerCode,
		tnf.FeedFundCode
FROM #TmpNewFund tnf


UPDATE fpd
SET 
	 fpd.FundTypeId = tuf.FundTypeId
	,fpd.Price = tuf.CurrentPrice
	,fpd.PriceDate = tuf.PriceDate
FROM 
	TFundPriceDenorm fpd
	INNER JOIN #TmpFundToUpdate tuf 
		ON tuf.FundUnitId = fpd.FundUnitId

INSERT INTO TFundPriceDenorm
SELECT 
	 tnf.FundUnitId
	,tnf.FundTypeId
	,tnf.CurrentPrice
	,tnf.PriceDate
FROM #TmpNewFund tnf


--add new equites
INSERT INTO #TmpNewEquity
SELECT 
	 eq.EquityId
	,eq.EquityName
	,eq.EpicCode
	,eq.ISINCode
	,eq.UpdatedFg
	,ROUND(	CASE
				WHEN ISNULL(ep.Bid, 0) > 0 THEN ep.Bid
	  			ELSE ep.Mid 
	  		END * ISNULL(cr.ExRate,1), 4)
	,ep.PriceDate
	,eq.Currency
FROM 
	fund2..TEquity eq
	JOIN fund2..TEquityPrice ep ON ep.EquityId = eq.EquityId
	LEFT JOIN #TmpExRate cr on cr.SourceCurrency = eq.currency
	LEFT OUTER JOIN TEquityDenorm eqd  ON eq.EquityId = eqd.EquityId
WHERE eqd.EquityId IS NULL

--update equites
INSERT INTO #TmpEquityToUpdate
SELECT 
	 eq.EquityId
	,eq.EquityName
	,eq.EpicCode
	,eq.ISINCode
	,eq.UpdatedFg
	,ROUND(	CASE
				WHEN ISNULL(ep.Bid, 0) > 0 THEN ep.Bid
	  			ELSE ep.Mid 
			END * ISNULL(cr.ExRate,1), 4)
	,ep.PriceDate
	,eq.Currency
FROM 
	fund2..TEquity eq
	JOIN TEquityDenorm eqd ON eqd.EquityId = eq.EquityId
	JOIN fund2..TEquityPrice ep ON ep.EquityId = eq.EquityId
	LEFT JOIN #TmpExRate cr on SourceCurrency = eq.currency
WHERE (IsNull(eqd.Name,'') <> IsNull(eq.EquityName,'') 
	   OR IsNull(eqd.EpicCode,'') <> IsNull(eq.EpicCode,'')
	   OR IsNull(eqd.ISINCode,'') <> IsNull(eq.ISINCode,'')
	   OR IsNull(eqd.Currency,'') <> IsNull(eq.Currency,'')
	   OR eqd.UpdatedFg <> eq.UpdatedFg)

UPDATE eqd
SET 
	eqd.Name = teuq.Name, 
	eqd.EpicCode = teuq.EpicCode,
	eqd.ISINCode = teuq.ISINCode,
	eqd.UpdatedFg = teuq.UpdatedFg,
	eqd.Currency = teuq.Currency
FROM 
	TEquityDenorm eqd
	INNER JOIN #TmpEquityToUpdate teuq 
		ON eqd.EquityId = teuq.EquityId

INSERT INTO TEquityDenorm
SELECT 
	 tneq.EquityId
	,tneq.Name
	,tneq.EpicCode
	,tneq.ISINCode
	,tneq.UpdatedFg
	,tneq.Currency
FROM 
	#TmpNewEquity tneq

UPDATE epd
SET
	 epd.Price = teuq.CurrentPrice
	,epd.PriceDate = teuq.PriceDate
FROM 
	TEquityPriceDenorm epd 
	JOIN #TmpEquityToUpdate teuq 
		ON epd.EquityId = teuq.EquityId

INSERT INTO TEquityPriceDenorm
SELECT 
	 tneq.EquityId
	,tneq.CurrentPrice
	,tneq.PriceDate
FROM 
	#TmpNewEquity tneq


DROP TABLE #TmpNewFund
DROP TABLE #TmpNewEquity
DROP TABLE #TmpFundToUpdate
DROP TABLE #TmpEquityToUpdate
DROP TABLE #TmpExRate