SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomDashboardRetrieveClientActivePlans]
	@TenantId bigint,
	@cid bigint
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


Declare @INFORCE_STATUS varchar(50) = (Select MIN(statusId) from TStatus Where IndigoClientId = @TenantId and IntelligentOfficeStatusType =  'In force')
Declare @PAIDUP_STATUS varchar(50) = (Select MIN(statusId) from TStatus Where IndigoClientId = @TenantId and IntelligentOfficeStatusType =  'Paid Up')

SELECT A.PolicyBusinessId, 
	A.PolicyDetailId,
	B.CRMContactId,
	A.PolicyNumber,
	ISNULL(A.ProductName, '') as ProductName,
	ISNULL(A.PropositionTypeId,0) as PropositionTypeId,
	prop.PropositionTypeName,
	Case  
		When (T11.ProdSubTypeName) Is Not Null 
		Then  ISNULL(F.CorporateName, '') + ' ' + ISNULL(T8.PlanTypeName, '') + '  (' + ISNULL(T11.ProdSubTypeName, '')  + ')'  
		Else  ISNULL(F.CorporateName, '') + ' ' + ISNULL(T8.PlanTypeName, '')   
	End as ProviderAndPlanType, -- Provider + plan Type
	1 as NumberOwners,
	Case when ISNULL(PropositionTypeName, '') = ''
		Then 2
		else 1
	end as EmptyOrder

INTO #Policies 
FROM TPolicyBusiness A
INNER JOIN TPolicyOwner B on A.PolicyDetailId = B.PolicyDetailId
INNER JOIN TStatusHistory C ON A.PolicyBusinessId = C.PolicyBusinessId
INNER JOIN TStatus D ON C.StatusId = D.StatusId -- in force and paid up only

-- Proposition 
LEFT JOIN crm..TPropositionType prop  ON A.PropositionTypeId = prop.PropositionTypeId
	
-- Plan type
INNER JOIN TPolicyDetail pd  on a.PolicyDetailId = pd.PolicyDetailId
INNER JOIN TPlanDescription pdesc  ON pd.PlanDescriptionId = pdesc.PlanDescriptionId
INNER JOIN TRefPlanType2ProdSubType T7  ON pdesc.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId 
LEFT JOIN TProdSubType T11  ON T7.ProdSubTypeId=T11.ProdSubTypeId
INNER JOIN TRefPlanType T8  ON T7.RefPlanTypeId = T8.RefPlanTypeId 

-- Provider 	
INNER JOIN TRefProdProvider E ON pdesc.RefProdProviderId = E.RefProdProviderId
INNER JOIN CRM..TCRMContact F ON E.CRMContactId = F.CRMContactId

-- Exclude Sub plans
Left Join  TWrapperPolicyBusiness G ON A.PolicyBusinessId = G.PolicyBusinessId

WHERE A.IndigoClientId = @TenantId
AND B.CRMContactId = @cid
AND C.StatusId IN (@INFORCE_STATUS, @PAIDUP_STATUS)
AND C.CurrentStatusFG = 1
AND A.TopupMasterPolicyBusinessId IS NULL -- no topups 
AND G.WrapperPolicyBusinessId IS NULL -- no sub plans 



-- Update the number of owners
Update A
Set NumberOwners = B.NumberOwners
FROM #Policies A
INNER JOIN
(
	SELECT A.PolicyDetailId, Count(1) as NumberOwners from TPolicyOwner A
	INNER JOIN #Policies B ON A.PolicyDetailId = B.PolicyDetailId
	GROUP BY A.PolicyDetailId
	HAVING COUNT(1) > 1
) B ON A.PolicyDetailId = B.PolicyDetailId


Select PolicyBusinessId, 
	PolicyDetailId,
	CRMContactId,
	ISNULL(ProductName, '') as ProductName,
	ISNULL(PolicyNumber, '') as PolicyNumber,
	PropositionTypeId,
	ISNULL(PropositionTypeName, '') as PropositionTypeName,
	ISNULL(ProviderAndPlanType, '') as ProviderAndPlanType,
	NumberOwners

from #Policies
order By EmptyOrder, PropositionTypeName, ProviderAndPlanType