SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpDashboardRetrieveClientPortfolioForLiabilities]
	@TenantId bigint,
	@cid bigint
AS
DECLARE @Plans TABLE (PolicyBusinessId bigint PRIMARY KEY, PolicyDetailId bigint, CurrencyCode varchar(3))
DECLARE @Rates TABLE (CurrencyCode[varchar](3), Rate decimal(18,10))
DECLARE @RegionalCurrency VARCHAR(3)
SELECT @RegionalCurrency = administration.dbo.FnGetRegionalCurrency()

DECLARE @Categories TABLE (Identifier varchar(50))
INSERT INTO @Categories
SELECT 'Mortgages'

-- Get list of policy business ids (so we can use these in the derived tables)
INSERT INTO @Plans
SELECT DISTINCT Pb.PolicyBusinessId, Pb.PolicyDetailId, pb.BaseCurrency
FROM
	TPolicyOwner PO
	JOIN TPolicyBusiness Pb ON Pb.PolicyDetailId = PO.PolicyDetailId AND Pb.IndigoClientId = @TenantId
	JOIN TStatusHistory Sh ON Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1
	JOIN TStatus S ON S.StatusId = Sh.StatusId AND s.IndigoClientId=@TenantId AND S.IntelligentOfficeStatusType IN ('In Force', 'Paid Up')			
WHERE
	PO.CRMContactId = @cid

INSERT INTO @Rates
SELECT DISTINCT CR.CurrencyCode, policymanagement.dbo.FnGetCurrencyRate(CR.CurrencyCode, @RegionalCurrency) AS Rate
FROM 
	@Plans P
	JOIN administration.dbo.TCurrencyRate CR ON P.CurrencyCode = CR.CurrencyCode AND CR.IndigoClientId = 0

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
	planTypes.Category,
	CASE 
		-- Special case for Equity Release   
		WHEN planTypes.PlanTypeName = 'Equity Release' THEN ISNULL((PAttr.AmountReleased * R.Rate), 0)
		ELSE -1 * isnull((M.LoanAmount * R.Rate),0)
	END as Value,
	CASE WHEN pb.CurrencyCode != @RegionalCurrency THEN 1 ELSE 0 END as AlternativeCurrency
INTO #Result
FROM 
	@Plans pb
	JOIN TPolicyDetail PD ON PD.PolicyDetailId = PB.PolicyDetailId
	JOIN TPlanDescription PDesc ON PDesc.PlanDescriptionId = Pd.PlanDescriptionId
	JOIN TRefPlanType2ProdSubType P2P ON P2P.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId 
	JOIN PlanTypes planTypes on P2P.RefPlanType2ProdSubTypeId = planTypes.RefPlanType2ProdSubTypeId
	JOIN @Rates R ON PB.CurrencyCode = R.CurrencyCode
	LEFT JOIN TMortgage M ON M.PolicyBusinessId = Pb.PolicyBusinessId
		
	--Equity Release Plan Types
	LEFT JOIN 
	(
		SELECT 
			CASE 
				WHEN ISNUMERIC(AttributeValue) = 1 THEN AttributeValue
				ELSE '0'
			END AS AmountReleased, pba.PolicyBusinessId
		FROM PolicyManagement..TPolicyBusinessAttribute pba
		JOIN @Plans p on p.PolicyBusinessId = pba.PolicyBusinessId
		JOIN PolicyManagement..TAttributeList2Attribute ala ON ala.AttributeList2AttributeId = pba.AttributeList2AttributeId
		JOIN PolicyManagement..TAttributelist al ON al.AttributeListId = ala.AttributeListId
		WHERE al.name = 'Amount Released'
	) PAttr ON PAttr.PolicyBusinessId = PB.PolicyBusinessId

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
