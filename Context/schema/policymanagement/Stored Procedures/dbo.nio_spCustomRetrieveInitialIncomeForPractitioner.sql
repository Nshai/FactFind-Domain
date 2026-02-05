SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_spCustomRetrieveInitialIncomeForPractitioner]
(		
	@AdviserCRMContactId bigint	
)
AS


Declare @InitialFee varchar(20) = 'Initial Fee'
Declare @DeletedStatus varchar(20) = 'Deleted'
Declare @CancelledStatus varchar(20) = 'Cancelled'



Declare @PractitionerId INT, 
		@TenantId INT

SELECT  @PractitionerId = PractitionerId, @TenantId = IndClientId from crm..TPractitioner with(nolock) where CRMContactId = @AdviserCRMContactId


IF OBJECT_ID('tempdb..#OutStandingBusiness') IS NOT NULL
begin
  DROP TABLE #OutStandingBusiness
end

Create Table #OutStandingBusiness(Id Int Identity(1,1) not null, BusinessType varchar(20),
	Owner1CRMContactId int null, Owner1Name VarChar(500) null, Owner2CRMContactId int null, Owner2Name VarChar(500) null,
 	IncomeType VarChar(250), FeeId int null, FeeRef varchar(20), [FeeStatus] varchar(50) null, 
	PolicyBusinessId int null, PolicyRef varchar(20) null, PlanStatus varchar(250) null, Provider varchar(250) null, PlanType varchar(250) null,
	ExpectedInitialIncome money default(0), ReceivedInitialIncome  money default(0), OutstandingInitialIncome money default(0)
) 

CREATE NONCLUSTERED INDEX [OutStandingBusiness_FeeId]
ON #OutStandingBusiness ([FeeId])

CREATE NONCLUSTERED INDEX [OutStandingBusiness_PolicyBusinessId]
ON #OutStandingBusiness ([PolicyBusinessId])

CREATE NONCLUSTERED INDEX [OutStandingBusiness_PolicyBusinessId_FeeId]
ON #OutStandingBusiness ([PolicyBusinessId], [FeeId])

CREATE NONCLUSTERED INDEX [OutStandingBusiness_FeeStatusId_FeeId]
ON #OutStandingBusiness ([FeeStatus],[FeeId])


-- Plans Expected Commission
Insert into #OutStandingBusiness
Select 	
	'Plan',
	null,
	null,
	null,
	null,	
	'Initial',
	null,
	null,		
	null,	
	pb.PolicyBusinessId,
	pb.SequentialRef,
	s.Name,
	T10.CorporateName,		-- Provider
	Case  
		When (T11.ProdSubTypeName) Is Not Null 
		Then  T8.PlanTypeName + '  (' + ISNULL(T11.ProdSubTypeName, '')  + ')'  
		Else  T8.PlanTypeName   
	End, -- plan Type	
	0,
	0,
	0
From  TPolicyBusiness pb   with(nolock)
INNER JOIN TStatusHistory SH WITH(NOLOCK) ON SH.PolicyBusinessId = pb.PolicyBusinessId AND SH.CurrentStatusFg = 1
INNER JOIN TStatus S WITH(NOLOCK) ON S.StatusId = SH.StatusId AND S.IntelligentOfficeStatusType <> @DeletedStatus
  --All these joins just to get plan type and Provider 
  Inner join TPolicyDetail T1 with (nolock) ON pb.PolicyDetailId = T1.PolicyDetailId	
  INNER JOIN TPlanDescription T6 with (nolock) ON T1.PlanDescriptionId = T6.PlanDescriptionId 
  INNER JOIN TRefPlanType2ProdSubType T7 with (nolock) ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId 
  LEFT JOIN TProdSubType T11 with (nolock) ON T7.ProdSubTypeId=T11.ProdSubTypeId
  INNER JOIN TRefPlanType T8 with (nolock) ON T7.RefPlanTypeId = T8.RefPlanTypeId 
  INNER JOIN TRefProdProvider T9 with (nolock) ON T6.RefProdProviderId = T9.RefProdProviderId 
  INNER JOIN [CRM].[dbo].TCRMContact T10 with (nolock) ON  T9.CRMContactId = T10.CRMContactId

WHERE pb.IndigoClientId = @TenantId AND pb.PractitionerId = @PractitionerId

--Update the Owner 1 Names
Update #OutStandingBusiness
Set Owner1CRMContactId = c.CRMContactId, 
	Owner1Name = ISNULL(E.CorporateName, '') + ISNULL(E.FirstName, '') + ' ' + ISNULL(E.LastName, '')
From #OutStandingBusiness A
Inner join TPolicyBusiness B with (nolock) ON A.PolicyBusinessId = B.PolicyBusinessId
Inner join TPolicyOwner C with (nolock) ON B.PolicyDetailId = C.PolicyDetailId
inner join
(
	Select Min(PolicyOwnerId) as PolicyOwnerId, A.PolicyDetailId from TPolicyOwner A with (nolock)
	Inner join TPolicyBusiness B with (nolock) ON A.PolicyDetailId = B.PolicyDetailId
	Inner join #OutStandingBusiness C ON B.PolicyBusinessId = C.PolicyBusinessId
	group by A.PolicyDetailId

) D ON C.PolicyOwnerId = D.PolicyOwnerId -- Min = Owner 1 (This is SO BAD)
Inner Join CRM..TCRMContact E ON C.CRMContactId = e.CRMContactId


--Update the Owner 2 Names (OMG this is worst code I've ever had to write)
Update #OutStandingBusiness
Set Owner2CRMContactId = c.CRMContactId, 
	Owner2Name = ISNULL(E.CorporateName, '') + ISNULL(E.FirstName, '') + ' ' + ISNULL(E.LastName, '')
From #OutStandingBusiness A
Inner join TPolicyBusiness B with (nolock) ON A.PolicyBusinessId = B.PolicyBusinessId
Inner join TPolicyOwner C with (nolock) ON B.PolicyDetailId = C.PolicyDetailId
inner join
(
	Select C.Id,  Max(PolicyOwnerId) as PolicyOwnerId, A.PolicyDetailId from TPolicyOwner A -- (need to group by C.Id as well as the same policy ca appear multiple times, which affects the group by  / count)
	Inner join TPolicyBusiness B with (nolock) ON A.PolicyDetailId = B.PolicyDetailId
	Inner join #OutStandingBusiness C with (nolock) ON B.PolicyBusinessId = C.PolicyBusinessId --and FeeId IS NOT NULL
	Group BY C.Id,  A.PolicyDetailId
	Having Count(PolicyOwnerId) > 1 -- must have a more than one Owner

) D ON C.PolicyOwnerId = D.PolicyOwnerId -- Max = Owner 2 (This is SO BAD)
Inner Join CRM..TCRMContact E ON C.CRMContactId = e.CRMContactId




IF OBJECT_ID('tempdb..#PlanIncomeTypes') IS NOT NULL
begin
  DROP TABLE #PlanIncomeTypes
end

CREATE TABLE #PlanIncomeTypes(PolicyBusinessId Int not null, CountUniqueIncomeType int, MinCommissionTypeName VarChar(250))

CREATE NONCLUSTERED INDEX [PlanIncomeTypes_PolicyBusinessId]
ON #PlanIncomeTypes ([PolicyBusinessId])


INSERT INTO #PlanIncomeTypes
SELECT DISTINCT B.policyBusinessId, COUNT( DISTINCT CommissionTypeName) , MIN(CommissionTypeName)
FROM   #OutStandingBusiness A
INNER JOIN TPolicyExpectedCommission B with(nolock) ON A.PolicyBusinessId = B.PolicyBusinessId
INNER JOIN TRefCommissionType C with(nolock) ON B.RefCommissionTypeId = C.RefCommissionTypeId
INNER JOIN TPolicyBusiness D with(nolock) ON B.PolicyBusinessId = D.PolicyBusinessId
Where C.InitialCommissionFg = 1
GROUP BY B.policyBusinessId
ORDER BY B.PolicyBusinessId


-- Update Income  Type
Update #OutStandingBusiness
Set IncomeType = B.MinCommissionTypeName
From #OutStandingBusiness A
Inner join #PlanIncomeTypes B ON A.PolicyBusinessId = B.PolicyBusinessId 
WHERE B.CountUniqueIncomeType = 1


--Do Client Paid Fees after, as we already have the Id's and Names of Both 


IF OBJECT_ID('tempdb..#FeeToPolicy') IS NOT NULL
begin
  DROP TABLE #FeeToPolicy
end

Create Table #FeeToPolicy( FeeId int, CountOfLinkedPlans int, PolicyBusinessId int) -- gets all plan linked Fees
CREATE NONCLUSTERED INDEX [FeeToPolicy_FeeId]
ON #FeeToPolicy ([FeeId])

CREATE NONCLUSTERED INDEX [FeeToPolicy_FeeId_CountOfLinkedPlans]
ON #FeeToPolicy ([FeeId], [CountOfLinkedPlans])


Insert into #FeeToPolicy 
Select A.FeeId, Count(1), Min(PolicyBusinessId)
from TFeeRetainerOwner A
Inner join TFee2Policy B ON A.FeeId = B.FeeId
Where A.PractitionerId = @PractitionerId
Group BY A.FeeId
 

-- Plan Linked Fees ONLY
Insert into #OutStandingBusiness
Select 	Distinct 
	'Plan Linked Fee',
	C.CRMContactId,
	ISNULL(C.CorporateName, '') + ISNULL(C.FirstName, '') + ' ' + ISNULL(C.LastName, ''),
	E.CRMContactId,
	CASE WHEN E.CRMContactId IS NOT NULL THEN  ISNULL(E.CorporateName, '') + ISNULL(E.FirstName, '') + ' ' + ISNULL(E.LastName, '') ELSE '' END,
	
	aft.Name,
	A.FeeId ,
	A.SequentialRef,	
	null,

	null,
	null,
	null,
	null,	
	null,

	ISNULL(ISNULL(A.NetAmount, 0) + ISNULL(A.VatAmount, 0), 0),
	0,
	0

From  TFee  A  with(nolock)
Inner Join TFeeRetainerOwner B with (nolock) ON A.FeeId = B.FeeId
Inner join crm..TCRMContact C with (nolock) ON B.CRMContactId = C.CRMContactId
inner join TAdviseFeeType aft with(nolock) ON A.AdviseFeeTypeId = aft.AdviseFeeTypeId
inner JOIN TRefAdviseFeeType D with (nolock) ON aft.RefAdviseFeeTypeId = D.RefAdviseFeeTypeId
Left join crm..TCRMContact E with (nolock) ON B.SecondaryOwnerId = E.CRMContactId
INNER Join #FeeToPolicy F ON A.FeeId = F.FeeId -- Plan Linked Fees ONLY
WHERE B.PractitionerId = @PractitionerId
and D.IsInitial = 1


-- Update Plan Details for Plan Linked Fees - where ONLY ONE plan is linked - if more than one then leave blank
Update OB
Set PolicyBusinessId =  pb.PolicyBusinessId,
	PolicyRef= pb.SequentialRef,
	PlanStatus = s.Name,
	Provider = T10.CorporateName,	-- Provider
	PlanType =  Case  
		When (T11.ProdSubTypeName) Is Not Null 
		Then  T8.PlanTypeName + '  (' + ISNULL(T11.ProdSubTypeName, '')  + ')'  
		Else  T8.PlanTypeName   
	End -- plan Type
	
From  #OutStandingBusiness OB
INNER JOIN TFee A  with (nolock) ON OB.feeId = A.FeeId
Inner Join #FeeToPolicy B ON A.FeeId = B.FeeId AND CountOfLinkedPlans = 1 -- only show plan details where ONE liked plan otherwise Blank

inner Join TFee2Policy ftp with (nolock) ON B.FeeId = ftp.FeeId AND B.PolicyBusinessId = ftp.PolicyBusinessId -- policy Fees Only
inner join TPolicyBusiness pb  with (nolock) ON ftp.PolicyBusinessId = pb.PolicyBusinessId
inner join TAdviseFeeType aft with(nolock) ON A.AdviseFeeTypeId = aft.AdviseFeeTypeId
inner JOIN TRefAdviseFeeType D with (nolock) ON aft.RefAdviseFeeTypeId = D.RefAdviseFeeTypeId
INNER JOIN TStatusHistory SH WITH(NOLOCK) ON SH.PolicyBusinessId = pb.PolicyBusinessId AND SH.CurrentStatusFg = 1
INNER JOIN TStatus S WITH(NOLOCK) ON S.StatusId = SH.StatusId AND S.IntelligentOfficeStatusType <> @DeletedStatus
  --All these joins just to get plan type and Provider 
  Inner join TPolicyDetail T1 with (nolock) ON pb.PolicyDetailId = T1.PolicyDetailId	
  INNER JOIN TPlanDescription T6 with (nolock) ON T1.PlanDescriptionId = T6.PlanDescriptionId 
  INNER JOIN TRefPlanType2ProdSubType T7 with (nolock) ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId 
  LEFT JOIN TProdSubType T11 with (nolock) ON T7.ProdSubTypeId=T11.ProdSubTypeId
  INNER JOIN TRefPlanType T8 with (nolock) ON T7.RefPlanTypeId = T8.RefPlanTypeId 
  INNER JOIN TRefProdProvider T9 with (nolock) ON T6.RefProdProviderId = T9.RefProdProviderId 
  INNER JOIN [CRM].[dbo].TCRMContact T10 with (nolock) ON  T9.CRMContactId = T10.CRMContactId
WHERE D.IsInitial = 1



-- Fees not linked to plans
Insert into #OutStandingBusiness
Select 	
	'Fee',
	C.CRMContactId,
	ISNULL(C.CorporateName, '') + ISNULL(C.FirstName, '') + ' ' + ISNULL(C.LastName, ''),
	E.CRMContactId,
	CASE WHEN E.CRMContactId IS NOT NULL THEN  ISNULL(E.CorporateName, '') + ISNULL(E.FirstName, '') + ' ' + ISNULL(E.LastName, '') ELSE '' END,
	
	aft.Name,
	A.FeeId ,
	A.SequentialRef,	
	null,

	null,
	null,
	null,
	null,	
	null,

	ISNULL(ISNULL(A.NetAmount, 0) + ISNULL(A.VatAmount, 0), 0),
	0,
	0

From  TFee  A  with(nolock)
Inner Join TFeeRetainerOwner B with (nolock) ON A.FeeId = B.FeeId
Inner join crm..TCRMContact C with (nolock) ON B.CRMContactId = C.CRMContactId
inner join TAdviseFeeType aft with(nolock) ON A.AdviseFeeTypeId = aft.AdviseFeeTypeId
inner JOIN TRefAdviseFeeType D with (nolock) ON aft.RefAdviseFeeTypeId = D.RefAdviseFeeTypeId
Left join crm..TCRMContact E with (nolock) ON B.SecondaryOwnerId = E.CRMContactId
Left Join TFee2Policy ftp with (nolock) ON A.FeeId = ftp.FeeId
WHERE B.PractitionerId = @PractitionerId
and D.IsInitial = 1
and ftp.Fee2PolicyId IS NULL -- Client paid Fees only


--Update Fee Statuses
UPdate A
Set FeeStatus = C.[Status]
From #OutStandingBusiness A
Inner join 
(
	Select Max(FeeStatusId) as FeeStatusId, A.FeeId from TFeeStatus A  with(nolock)
	Inner Join #OutStandingBusiness B ON A.FeeId = B.FeeId
	Group By A.FeeId
) B ON A.FeeId = B.FeeId
Inner Join TFeeStatus C ON B.FeeStatusId = C.FeeStatusId

--Remove all fees that are cancelled status
Delete from #OutStandingBusiness Where FeeId IS NOT NULL and FeeStatus = @CancelledStatus

-- Expected Initial Values for all plans
UPDATE A 
	SET A.ExpectedInitialIncome = B.Amount
FROM #OutStandingBusiness A
INNER JOIN
(
	Select A.PolicyBusinessId, SUM(ISNULL(B.Amount, 0)) As Amount
	FROM #OutStandingBusiness A
	INNER JOIN 
	(	
		-- Expected Commisison Total
		SELECT A.PolicyBusinessId, ISNULL(SUM(ISNULL(B.ExpectedAmount, 0)), 0) AS Amount 
		FROM #OutStandingBusiness A 
		INNER JOIN TPolicyExpectedCommission B with(nolock) ON A.PolicyBusinessId = B.PolicyBusinessId
		INNER JOIN TRefCommissionType C with(nolock) ON B.RefCommissionTypeId = C.RefCommissionTypeId
		WHERE C.InitialCommissionFg = 1 -- initial only
		And A.FeeId IS NULL
		GROUP BY  A.PolicyBusinessId

	) B ON A.PolicyBusinessId = B.PolicyBusinessId
	where A.FeeId IS NULL
	Group BY  A.PolicyBusinessId

) B ON A.PolicyBusinessId = B.PolicyBusinessId
where A.FeeId IS NULL



-- Recieved Initial Values for all plans(not linked to a Fee)
UPDATE A 
	Set A.ReceivedInitialIncome = ISNULL(B.InitialAmountReceived, 0) -- THis needs to be changed to Initial received schema is updated
FROM #OutStandingBusiness A
Inner join commissions..TPaymentSummary B with(nolock) ON ISNULL(A.PolicyBusinessId, 0) = ISNULL(B.PolicyId, 0)
Where A.FeeId IS NULL and B.FeeId IS NULL and B.LinkedFeeId IS NULL


--Received Commission for All Fees (both linked and not linked)
UPDATE A 
	Set A.ReceivedInitialIncome = ISNULL(B.GrossAmountReceived, 0)
FROM #OutStandingBusiness A
INNER JOIN
(
	Select A.FeeId, Sum(ISNULL(B.GrossAmountReceived, 0)) as GrossAmountReceived -- all provider paid
	FROM #OutStandingBusiness A
	Inner join commissions..TPaymentSummary B with(nolock) ON ISNULL(A.FeeId, 0) = ISNULL(B.LinkedFeeId, 0)	
	Where A.FeeId IS NOT NULL and B.PolicyId IS NOT NULL and B.LinkedFeeId IS NOT NULL
	Group By A.FeeId
	
	UNION ALL
	
	Select A.FeeId, Sum(ISNULL(B.GrossAmountReceived, 0)) as GrossAmountReceived -- all client paid
	FROM #OutStandingBusiness A
	Inner join commissions..TPaymentSummary B with(nolock) ON ISNULL(A.FeeId, 0) = ISNULL(B.FeeId, 0)	
	Where A.FeeId IS NOT NULL and B.PolicyId IS NULL and B.LinkedFeeId IS NULL
	Group By A.FeeId
	
) B ON A.FeeId = B.FeeId



-- Recieved Initial Values for all Fees Linked to PLans
UPDATE A 
	Set A.OutstandingInitialIncome = ExpectedInitialIncome - ReceivedInitialIncome
FROM #OutStandingBusiness A




--Result
Select * from #OutStandingBusiness Where OutstandingInitialIncome > 0



--Drop Temp Tables


IF OBJECT_ID('tempdb..#OutStandingBusiness') IS NOT NULL
begin
  DROP TABLE #OutStandingBusiness
end

IF OBJECT_ID('tempdb..#FeeToPolicy') IS NOT NULL
begin
  DROP TABLE #FeeToPolicy
end


IF OBJECT_ID('tempdb..#PlanIncomeTypes') IS NOT NULL
begin
  DROP TABLE #PlanIncomeTypes
end