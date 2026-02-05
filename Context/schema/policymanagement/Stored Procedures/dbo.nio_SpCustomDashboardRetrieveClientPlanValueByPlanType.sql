SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[nio_SpCustomDashboardRetrieveClientPlanValueByPlanType]
	@UserId INT,
	@TenantId INT,
	@ClientId INT
AS


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Constants
Declare @InForceStatus varchar(20) = 'In force'
Declare @PaidUpStatus varchar(20) = 'Paid Up'
Declare @HasPlanInAlternativeCurrency bit = 0
DECLARE @RegionalCurrency VARCHAR(50)
SELECT @RegionalCurrency = administration.dbo.FnGetRegionalCurrency()

IF OBJECT_ID('tempdb..#Plans', 'U') IS NOT NULL
	DROP TABLE #Plans;

IF OBJECT_ID('tempdb..#Rates', 'U') IS NOT NULL
	DROP TABLE #Rates;

CREATE TABLE #Rates (CurrencyCode[varchar](3), Rate decimal(18,10))
CREATE TABLE #Plans (PolicyBusinessId INT, [Type] varchar(50), PropositionId int, Proposition Varchar(255), PlanType Varchar(255), PlanPurposes varchar(2000), Value decimal(18,10) default(0), CurrencyCode Varchar(3))

INSERT INTO #Plans
(PolicyBusinessId, [Type], PropositionId, Proposition, PlanType, CurrencyCode)
SELECT
	Pol.PolicyBusinessId,
	'Plan',
	Pol.PropositionTypeId,
	prop.PropositionTypeName,
	Case
		When (T11.ProdSubTypeName) Is Not Null
		Then  T8.PlanTypeName + '  (' + ISNULL(T11.ProdSubTypeName, '')  + ')'
		Else  T8.PlanTypeName
	End, -- plan Type
	BaseCurrency

FROM TPolicyBusiness Pol
	INNER JOIN TPolicyOwner Po ON Pol.PolicyDetailId = Po.PolicyDetailId
	INNER JOIN TStatusHistory SH ON SH.PolicyBusinessId = Pol.PolicyBusinessId AND SH.CurrentStatusFg = 1
	INNER JOIN TStatus S ON S.StatusId = SH.StatusId
	INNER JOIN crm..TPropositionType prop ON pol.PropositionTypeId = prop.PropositionTypeId
	INNER JOIN TPolicyDetail pd on pol.PolicyDetailId = pd.PolicyDetailId
	INNER JOIN TPlanDescription pdesc ON pd.PlanDescriptionId = pdesc.PlanDescriptionId
	INNER JOIN TRefPlanType2ProdSubType T7 ON pdesc.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId
    LEFT JOIN TProdSubType T11 ON T7.ProdSubTypeId=T11.ProdSubTypeId
	INNER JOIN TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId
WHERE Pol.IndigoClientId = @TenantID
	AND Po.CRMContactId = @ClientId
	AND S.IntelligentOfficeStatusType in(@InForceStatus, @PaidUpStatus) -- in force or Paid up only
OPTION (OPTIMIZE FOR UNKNOWN)

	--Remove wraps if plan valuation basis should ignore them
	DELETE p
	FROM #Plans p
	JOIN TPolicyBusinessTotalPlanValuationType t on p.PolicyBusinessId = t.PolicyBusinessId
	LEFT JOIN TWrapperPolicyBusiness w on p.PolicyBusinessId = w.ParentPolicyBusinessId
	LEFT JOIN TPlanValuation v on w.PolicyBusinessId = v.PolicyBusinessId
	WHERE t.RefTotalPlanValuationTypeId = 1 and v.PlanValuationId IS NOT NULL

	--Remove sub-plans if plan valuation basis should ignore them
	DELETE p
	FROM #Plans p
	JOIN TWrapperPolicyBusiness s on p.PolicyBusinessId = s.PolicyBusinessId
	JOIN TPolicyBusinessTotalPlanValuationType w on s.ParentPolicyBusinessId = w.PolicyBusinessId
	WHERE w.RefTotalPlanValuationTypeId = 3

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
Select  0, 'PlanType' as [Type],  PlanType as PlanType, NULL as Proposition, Sum(Value * R.Rate) as Value
from #Plans P
INNER JOIN #Rates R ON R.CurrencyCode = P.CurrencyCode
where [Type] = 'Plan'
Group BY PlanType
Having Sum(Value) > 0

Insert into #Plans
(PolicyBusinessId, [Type], PlanType, Proposition, Value)
Select  0 ,'Proposition',  PlanType, Proposition, Sum(Value * R.Rate)
from #Plans P
INNER JOIN #Rates R ON R.CurrencyCode = P.CurrencyCode
where [Type] = 'Plan'
Group BY PlanType, Proposition
Having Sum(Value) > 0

-- Concattenates the plan purposes per
Update A
Set A.PlanPurposes = B.PlanPurposes
From #Plans A
Inner Join
(
	SELECT PlanType, PlanPurposes =
		STUFF((SELECT Distinct ', ' + C.Descriptor
			  from #Plans A
				Inner join TPolicyBusinessPurpose B ON A.PolicyBusinessId = B.PolicyBusinessId
				inner join TPlanPurpose C ON B.PlanPurposeId = C.PlanPurposeId
			   WHERE a.PlanType= d.PlanType
			  FOR XML PATH('')), 1, 2, '')

	 from #Plans d
		Inner join TPolicyBusinessPurpose e ON d.PolicyBusinessId = e.PolicyBusinessId
		inner join TPlanPurpose f ON e.PlanPurposeId = f.PlanPurposeId
	GROUP BY PlanType
) B ON A.PlanType = B.PlanType
Where A.[Type] = 'PlanType'


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