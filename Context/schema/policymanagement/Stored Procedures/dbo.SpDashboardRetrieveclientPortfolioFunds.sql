USE policymanagement
GO
/*
Modification History (most recent first)
Date        Modifier        Issue       Description
----        ---------       -------     -------------
20191024    Nick Fairway    IP-62229    Performance issue. Inconsistent performance  - looks like parameter sniffing so optimize for unknown.
20201029    Nick Fairway    IP-90479    Performance issue. SDA-9 index changes necessitate improvements 

*/ 
CREATE PROCEDURE dbo.SpDashboardRetrieveclientPortfolioFunds
 @cid BIGINT
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SET NOCOUNT ON

	DECLARE @IndigoClientId BIGINT
	DECLARE @RegionalCurrency NCHAR(3)
	
	SELECT @RegionalCurrency = administration.dbo.FnGetRegionalCurrency()

	SET @indigoClientId = (SELECT IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @cid)

	IF (SELECT object_id('tempdb..#work0')) IS NOT NULL DROP TABLE #work0
	IF (SELECT object_id('tempdb..#work1')) IS NOT NULL DROP TABLE #work1
	IF (SELECT object_id('tempdb..#Rates')) IS NOT NULL DROP TABLE #Rates
    
	CREATE TABLE #Rates (CurrencyCode nchar(3), Rate decimal(18,10))

	SELECT 
        MIN(CRMContactId) AS CRMContactId,   
        PolicyDetailId
    INTO #work0
    FROM TPolicyOwner 
    WHERE CRMContactId = @cid
    GROUP BY PolicyDetailId

	SELECT d.fundid, d.FromFeedFg, d.EquityFg, CAST(d.CurrentUnitQuantity AS decimal(18,10)) AS CurrentUnitQuantity, CAST(d.CurrentPrice AS decimal(18,10)) AS CurrentPrice, c.BaseCurrency AS CurrencyCode, D.FundIndigoClientId, D.PolicyBusinessId
	INTO #work1
	FROM #work0 A
	JOIN dbo.TPOlicyDetail          B   ON  A.PolicyDetailId    = B.PolicyDetailId
	JOIN dbo.TPolicyBusiness        C   ON  B.PolicyDetailId    = C.PolicyDetailId
	JOIN dbo.TPolicyBusinessFund    D   ON  C.PolicyBusinessId  = D.PolicyBusinessId
	JOIN dbo.TStatusHistory         E   ON  E.PolicyBusinessId  = D.PolicyBusinessId 
                                        AND E.CurrentStatusFg   = 1
	JOIN dbo.TStatus                F   ON  F.StatusId          = E.StatusId 
                                    AND F.IndigoClientId        = C.IndigoClientId 
                                    AND F.IntelligentOfficeStatusType IN ('In Force', 'Paid Up')

	INSERT INTO #Rates (CurrencyCode, Rate)
	SELECT R.CurrencyCode, policymanagement.dbo.FnGetCurrencyRate(R.CurrencyCode, @RegionalCurrency) AS Rate
	FROM administration..TCurrencyRate R
	INNER JOIN (SELECT DISTINCT CurrencyCode
				FROM #work1) P ON P.CurrencyCode = R.CurrencyCode
	WHERE IndigoClientId = 0

	SELECT ISNULL(Fu.Name, 'Unknown') AS FundUniverseName,isnull(sum(pbf.CurrentUnitQuantity * pbf.CurrentPrice * RT.Rate),0) as FundValue
	FROM        #work1                          pbf
	INNER JOIN  #Rates                          RT  ON RT.CurrencyCode      = pbf.CurrencyCode   
	LEFT JOIN   fund2..TFundUnit                FT  ON FT.FundUnitId        = pbf.FundId AND FromFeedFg = 1 AND EquityFg = 0
	LEFT JOIN   dbo.TNonFeedFund                NF  ON NF.NonFeedFundId     = pbf.FundId AND FromFeedFg = 0 AND EquityFg = 0
	LEFT JOIN   fund2..TFund2RefFundUniverse    FFU ON FFu.FundId           = FT.FundId 
	LEFT JOIN   fund2..TFundSector              FS  ON Fs.FundSectorId      = NF.CategoryId
	LEFT JOIN   fund2..TRefFundUniverse         Fu  ON Fu.RefFundUniverseId = FFU.RefFundUniverseId 
                                                    OR FS.RefFundUniverseId = FU.RefFundUniverseId

	LEFT JOIN dbo.TPolicyBusinessFund       x   
	ON  x.EquityFg = 1 
	AND x.FromFeedFg = 1 
	AND pbf.FundId = x.FundId 
	AND pbf.FundIndigoClientId  = x.FundIndigoClientId
	AND pbf.PolicyBusinessId    = x.PolicyBusinessId
	WHERE   x.PolicyBusinessFundId IS NULL
	GROUP BY Fu.Name

	UNION ALL

	SELECT 'Equity' AS FundUniverseName,isnull(sum(pbf.CurrentUnitQuantity * pbf.CurrentPrice * RT.Rate),0) as FundValue
	FROM    #work1          pbf
	JOIN    #Rates          RT ON RT.CurrencyCode = pbf.CurrencyCode   
	JOIN    fund2..TEquity  Eq ON Eq.EquityId = pbf.FundId AND EquityFg = 1
	GROUP BY Eq.EquityId
END
GO
