SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpDashboardRetrieveClientPortfolioForInvestment]
	@TenantId bigint,
	@cid bigint
AS

set transaction isolation level read uncommitted

DECLARE @Plans TABLE (PolicyBusinessId bigint PRIMARY KEY, PolicyDetailId bigint, CurrencyCode varchar(3))
DECLARE @Rates TABLE (CurrencyCode[varchar](3), Rate decimal(18,10))
DECLARE @RegionalCurrency VARCHAR(3)
DECLARE @Assets TABLE (PolicyBusinessId bigint, Amount decimal(18,10), CurrencyCode varchar(3), AlternativeCurrencyFg int)
SELECT @RegionalCurrency = administration.dbo.FnGetRegionalCurrency()

DECLARE @Categories TABLE (Identifier varchar(50))
INSERT INTO @Categories
SELECT 'Investments'
UNION SELECT 'Pensions'
UNION SELECT 'Other Assets'

-- Get list of policy business ids (so we can use these in the derived tables)
INSERT INTO @Plans
SELECT DISTINCT Pb.PolicyBusinessId, Pb.PolicyDetailId, Pb.BaseCurrency
FROM
	TPolicyOwner PO
	JOIN TPolicyBusiness Pb ON Pb.PolicyDetailId = PO.PolicyDetailId AND Pb.IndigoClientId = @TenantId
	JOIN TStatusHistory Sh ON Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1
	JOIN TStatus S ON S.StatusId = Sh.StatusId AND s.IndigoClientId=@TenantId AND S.IntelligentOfficeStatusType IN ('In Force', 'Paid Up')			
WHERE
	PO.CRMContactId = @cid

INSERT INTO @Assets
SELECT
	a.PolicyBusinessId,
	Amount AS [Amount],
	a.CurrencyCode,
	CASE WHEN A.CurrencyCode != @RegionalCurrency AND isnull(Amount,0) != 0 THEN 1 ELSE 0 END as AlternativeCurrencyFg
FROM
	FactFind..TAssets a
	join @Plans p on a.PolicyBusinessId = p.PolicyBusinessId
WHERE
	CRMContactId = @cid

INSERT INTO @Rates
SELECT DISTINCT CR.CurrencyCode, policymanagement.dbo.FnGetCurrencyRate(CR.CurrencyCode, @RegionalCurrency) AS Rate
FROM 
	@Plans P
	JOIN administration.dbo.TCurrencyRate CR ON P.CurrencyCode = CR.CurrencyCode AND CR.IndigoClientId = 0

UNION 

SELECT DISTINCT CR.CurrencyCode, policymanagement.dbo.FnGetCurrencyRate(CR.CurrencyCode, @RegionalCurrency) AS Rate
FROM 
	@Assets A
	JOIN administration.dbo.TCurrencyRate CR ON A.CurrencyCode = CR.CurrencyCode AND CR.IndigoClientId = 0

--If there are no records in Reporter..TPlanSetting, then consider Tenant = 0 to get PlanType data
DECLARE @PlanSettingTenantId bigint = 0
If EXISTS (SELECT 1 FROM Reporter..TPlanSetting WHERE TenantId = @TenantId)
	SET @PlanSettingTenantId = @TenantId
	
--Get the plan types we are interested in
;WITH PlanTypes (RefPlanType2ProdSubTypeId,PlanTypeName,Category)
AS
(
select P2P.RefPlanType2ProdSubTypeId, Rpt.PlanTypeName as PlanTypeName,  Ffc.Identifier as Category
from  TRefPlanType2ProdSubType P2P 
	 	JOIN Reporter..TPlanSetting Tps On Tps.RefPlanType2ProdSubTypeId = P2P.RefPlanType2ProdSubTypeId and Tps.TenantId=@PlanSettingTenantId
	 	JOIN TRefPlanType Rpt ON Rpt.RefPlanTypeId = P2P.RefPlanTypeId	 	
		JOIN Reporter..TRefPlanCategory Ffc ON Ffc.RefPlanCategoryId = Tps.RefPlanCategoryId
		JOIN @Categories c on c.Identifier = ffc.Identifier
)
	
SELECT 
		planTypes.PlanTypeName as PlanTypeName,
		planTypes.Category as Category,		
		CASE WHEN Fund.FundValue IS NOT NULL OR Assets.Amount IS NOT NULL 
			THEN ISNULL((Fund.FundValue * R.Rate), 0) + ISNULL(Assets.Amount, 0) 
			ELSE ISNULL((LastVal.PlanValue * R.Rate), 0)
		END as Value,
		IIF(AssetAlternativeCurrency = 1 OR pb.CurrencyCode != @RegionalCurrency, 1, 0) as AlternativeCurrency
	INTO #Result
	FROM 
		@Plans pb
		JOIN TPolicyDetail PD ON PD.PolicyDetailId = PB.PolicyDetailId
		JOIN TPlanDescription PDesc ON PDesc.PlanDescriptionId = Pd.PlanDescriptionId
		JOIN TRefPlanType2ProdSubType P2P ON P2P.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId 
		JOIN PlanTypes planTypes on P2P.RefPlanType2ProdSubTypeId = planTypes.RefPlanType2ProdSubTypeId
		JOIN @Rates R ON PB.CurrencyCode = R.CurrencyCode
		LEFT JOIN 
		(
			SELECT 
				v.PolicyBusinessId,
				v.PlanValueDate,
				v.PlanValue
			FROM TPlanValuation v
			JOIN @Plans p ON v.PolicyBusinessId = p.PolicyBusinessId
			WHERE (
				SELECT TOP 1 v1.PlanValuationId
                FROM dbo.TPlanValuation v1
                WHERE v1.PolicyBusinessId = p.PolicyBusinessId
                ORDER BY v1.PlanValueDate DESC, v1.PlanValuationId DESC
			) = v.PlanValuationId
		) AS LastVal ON pb.PolicyBusinessId = LastVal.PolicyBusinessId
		LEFT JOIN TMortgage M ON M.PolicyBusinessId = Pb.PolicyBusinessId
		-- Fund Valuation
		LEFT JOIN 
			(
			SELECT			
				pbf.PolicyBusinessId,
				SUM(ISNULL(CurrentPrice, 0) * ISNULL(CurrentUnitQuantity, 0)) AS FundValue
			FROM
				@Plans p
				JOIN PolicyManagement..TPolicyBusinessFund pbf WITH(NOLOCK) ON p.PolicyBusinessId = pbf.PolicyBusinessId
			GROUP BY pbf.PolicyBusinessId
			) AS Fund ON Fund.PolicyBusinessId = Pb.PolicyBusinessId
		-- Assets
		LEFT JOIN
		(
			SELECT
				a.PolicyBusinessId,
				SUM(Amount * R.Rate) AS [Amount],
				MAX(AlternativeCurrencyFg) AS AssetAlternativeCurrency
			FROM
				@Assets a
				JOIN @Rates R ON A.CurrencyCode = R.CurrencyCode
			GROUP BY
				a.PolicyBusinessId
		) AS Assets ON Assets.PolicyBusinessId = Pb.PolicyBusinessId

UPDATE #Result
SET AlternativeCurrency = 0
WHERE ISNULL([Value], 0) = 0

SELECT [PlanTypeName], 
	   ISNULL(SUM([Value]), 0) as Value,
	   MAX(AlternativeCurrency) AS HasPlansInAlternativeCurrency 
FROM #Result
GROUP BY 
	PlanTypeName, Category
ORDER BY PlanTypeName
GO
