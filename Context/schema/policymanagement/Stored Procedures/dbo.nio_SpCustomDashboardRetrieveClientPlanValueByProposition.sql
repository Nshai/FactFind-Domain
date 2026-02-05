SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.nio_SpCustomDashboardRetrieveClientPlanValueByProposition
	@UserId INT,
	@TenantId INT,
	@ClientId INT,
	@planType INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


DECLARE @Category Varchar(50)
DECLARE @HasPlanInAlternativeCurrency bit = 0
DECLARE @RegionalCurrency VARCHAR(3)


DROP TABLE IF EXISTS #Plans, #Rates;
CREATE TABLE #Rates (CurrencyCode[varchar](3), Rate decimal(18,10))
CREATE TABLE #Plans (PolicyBusinessId INT, [Type] varchar(50), PropositionId int, Proposition Varchar(255), PlanType Varchar(255), PlanPurposes varchar(2000), Value decimal(18,10) default(0), CurrencyCode varchar(3))



SELECT @RegionalCurrency = administration.dbo.FnGetRegionalCurrency()

IF @planType = 0
BEGIN 
	Set @Category = 'Investments'
END

IF @planType = 1
BEGIN 
	Set @Category = 'Pensions'
END

--If there are no records in Reporter..TPlanSetting, then consider Tenant = 0 to get PlanType data
DECLARE @PlanSettingTenantId bigint = 0
If EXISTS (SELECT 1 FROM Reporter..TPlanSetting with(nolock) WHERE TenantId = @TenantId)
	SET @PlanSettingTenantId = @TenantId

-- Need plan type id's for the relevant Portfolio Plan Types Category
Declare @PlanTypes Table (RefPlanType2ProdSubTypeId int, PlanTypeName varchar(500), Category varchar(500))
insert into @PlanTypes
select P2P.RefPlanType2ProdSubTypeId, Rpt.PlanTypeName,  Ffc.Identifier
from  TRefPlanType2ProdSubType P2P 
	 	JOIN Reporter..TPlanSetting Tps On Tps.RefPlanType2ProdSubTypeId = P2P.RefPlanType2ProdSubTypeId and Tps.TenantId=@PlanSettingTenantId
	 	JOIN TRefPlanType Rpt ON Rpt.RefPlanTypeId = P2P.RefPlanTypeId	 	
		JOIN Reporter..TRefPlanCategory Ffc ON Ffc.RefPlanCategoryId = Tps.RefPlanCategoryId
Where ffc.Identifier = @Category

--Constants
Declare @InForceStatus varchar(20) = 'In force'
Declare @PaidUpStatus varchar(20) = 'Paid Up'


INSERT INTO #Plans 
(PolicyBusinessId, [Type], PropositionId, Proposition, PlanType, CurrencyCode)
SELECT 
	Pol.PolicyBusinessId,
	'Plan',
	pb.PropositionTypeId,
	prop.PropositionTypeName,
	Case  
		When (T11.ProdSubTypeName) Is Not Null 
		Then  T8.PlanTypeName + '  (' + ISNULL(T11.ProdSubTypeName, '')  + ')'  
		Else  T8.PlanTypeName   
	End, -- plan Type
	pb.BaseCurrency

FROM dbo.TPolicyOwner Po
	INNER JOIN dbo.TPolicyBusiness Pol WITH(NOLOCK) ON Pol.PolicyDetailId = Po.PolicyDetailId
	join TPolicyBusiness pb ON Pol.PolicyBusinessId = Pb.PolicyBusinessId -- join back on the PK_PolicyBusiness index to lookup up PropositionTypeId & BaseCurrency
	INNER JOIN TStatusHistory SH WITH(NOLOCK) ON SH.PolicyBusinessId = Pol.PolicyBusinessId AND SH.CurrentStatusFg = 1
	INNER JOIN TPolicyDetail pd with(nolock) on pol.PolicyDetailId = pd.PolicyDetailId
	INNER JOIN TPlanDescription pdesc with(NOLOCK) ON pd.PlanDescriptionId = pdesc.PlanDescriptionId
	INNER JOIN crm..TPropositionType prop WITH(NOLOCK) ON pol.PropositionTypeId = prop.PropositionTypeId
	INNER JOIN TRefPlanType2ProdSubType T7 with (nolock) ON pdesc.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId 
	INNER JOIN TStatus S WITH(NOLOCK) ON S.StatusId = SH.StatusId
	INNER JOIN TRefPlanType T8 with (nolock) ON T7.RefPlanTypeId = T8.RefPlanTypeId
	inner Join @PlanTypes PT ON T7.RefPlanType2ProdSubTypeId = PT.RefPlanType2ProdSubTypeId -- Portfolio Plan Types Category
    LEFT JOIN TProdSubType T11 with (nolock) ON T7.ProdSubTypeId=T11.ProdSubTypeId 
	
WHERE Pol.IndigoClientId = @TenantID
	AND Po.CRMContactId = @ClientId -- 
	AND S.IntelligentOfficeStatusType in (@InForceStatus, @PaidUpStatus) -- in force or Paid up only
OPTION (OPTIMIZE FOR UNKNOWN)


--Update the Value
Update p
	Set Value = ISNULL(LastVal.PlanValue, 0)
From #Plans p
INNER JOIN 
(
	SELECT
		v.PolicyBusinessId,
		v.PlanValueDate,
		v.PlanValue
	FROM TPlanValuation v
	JOIN #Plans p ON v.PolicyBusinessId = p.PolicyBusinessId
	WHERE 
		(
			SELECT TOP 1 v1.PlanValuationId
			FROM dbo.TPlanValuation v1
			WHERE v1.PolicyBusinessId = p.PolicyBusinessId
			ORDER BY v1.PlanValueDate DESC, v1.PlanValuationId DESC
		) = v.PlanValuationId
) AS LastVal ON LastVal.PolicyBusinessId = p.PolicyBusinessId

INSERT INTO #Rates (CurrencyCode, Rate)
	SELECT R.CurrencyCode, policymanagement.dbo.FnGetCurrencyRate(R.CurrencyCode, @RegionalCurrency) AS Rate
	FROM administration..TCurrencyRate R
	INNER JOIN (SELECT DISTINCT CurrencyCode
				FROM #Plans) P ON P.CurrencyCode = R.CurrencyCode
	WHERE IndigoClientId = 0

SELECT TOP 1 @HasPlanInAlternativeCurrency = 1
FROM #Plans
WHERE CurrencyCode != @RegionalCurrency AND Value > 0

Insert into #Plans
(PolicyBusinessId, [Type], PlanType, Proposition, Value)
Select  0 ,'Proposition',  NULL, Proposition, Sum(Value * R.Rate)
from #Plans P
INNER JOIN #Rates R ON R.CurrencyCode = P.CurrencyCode
where [Type] = 'Plan'
Group BY Proposition
Having Sum(Value) > 0

Insert into #Plans
(PolicyBusinessId, [Type], PlanType, Proposition, Value)
Select 	0, 'PlanType' as [Type],  PlanType as PlanType, Proposition as Proposition, Sum(Value * R.Rate) as Value
from #Plans P
INNER JOIN #Rates R ON R.CurrencyCode = P.CurrencyCode
where [Type] = 'Plan'
Group BY Proposition, PlanType
Having Sum(Value) > 0;

-- Concatenates the plan purposes per 
WITH PlanTypeDescriptor AS (
	SELECT C.Descriptor, a.PlanType
	FROM #Plans A
	INNER JOIN dbo.TPolicyBusinessPurpose B ON A.PolicyBusinessId = B.PolicyBusinessId
	INNER JOIN dbo.TPlanPurpose C ON B.PlanPurposeId = C.PlanPurposeId
	GROUP BY C.Descriptor, a.PlanType
), PlanTypePurposes AS (
	SELECT PlanType, PlanPurposes=STRING_AGG(C.Descriptor, ', ') WITHIN GROUP (ORDER BY C.Descriptor)
	FROM PlanTypeDescriptor C
	GROUP BY PlanType
)

Update p
Set PlanPurposes = ptp.PlanPurposes
From #Plans p
JOIN PlanTypePurposes ptp ON p.PlanType = ptp.PlanType
Where p.[Type] = 'PlanType'

--############################################
--RESULTS
--############################################
Select [Type], PlanType, Proposition, PlanPurposes, Value, @HasPlanInAlternativeCurrency
From #Plans A
Where A.[Type] != 'Plan' -- only want plan type and propostion aggregates

IF OBJECT_ID('tempdb..#Plans', 'U') IS NOT NULL
	DROP TABLE #Plans; 

IF OBJECT_ID('tempdb..#Rates', 'U') IS NOT NULL
	DROP TABLE #Rates;
GO

