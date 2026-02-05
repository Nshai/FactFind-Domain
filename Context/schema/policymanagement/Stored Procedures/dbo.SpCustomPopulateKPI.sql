SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomPopulateKPI]
AS

SET NOCOUNT ON

TRUNCATE TABLE TKpi

-- Initial insert takes summary information for each practitioner about policies submitted/issued/cancelled etc
INSERT INTO TKpi (
	IndigoClientId,
	ContactId,
	Contact,
	Submitted,
	Switched,
	InForce,
	Cancelled,
	NTU,
	CategoryId,
	Category,
	PlanTypeId,
	PlanType,
	ProviderId,
	Provider,
	ClientId,
	Client, 
	StatusDate)
SELECT
	T4.IndClientId,
	T4.CRMContactId,
	T4.FirstName + ' ' + T4.LastName,
	'Submitted' = CASE WHEN T5.StatusId = 4 THEN 1 ELSE 0 END,
	'Switched' = CASE WHEN T6.SwitchId IS NULL THEN 0 ELSE 1 END,
	'InForce' = CASE WHEN T5.StatusId = 2 THEN 1 ELSE 0 END,
	0,
	0,
	T9.RefPlanTypeId,
	T9.PlanTypeName,
	T11.PlanCategoryId,
	T11.PlanCategoryName,
	T13.CRMContactId,
	T13.CorporateName,
	T15.CRMContactId,
	T15.FirstName + ' ' + T15.LastName,
	T5.ChangedToDate
FROM
	-- Submitted / InForce information
	PolicyManagement..TPolicyDetail T1
	JOIN PolicyManagement..TPolicyBusiness T2 ON T2.PolicyDetailId = T1.PolicyDetailId
	JOIN CRM..TPractitioner T3 ON T3.PractitionerId = T2.PractitionerId
	JOIN CRM..TCRMContact T4 ON T4.CRMContactId = T3.CRMContactId
	JOIN PolicyManagement..TStatusHistory T5 ON T5.PolicyBusinessId = T2.PolicyBusinessId
	LEFT JOIN PolicyManagement..TSwitch T6 ON T6.PolicyBusinessId = T2.PolicyBusinessId
	-- Plan Type information
	JOIN PolicyManagement..TPlanDescription T7 ON T7.PlanDescriptionId = T1.PlanDescriptionId
	JOIN PolicyManagement..TRefPlanType2ProdSubType T8 ON T8.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId
	JOIN PolicyManagement..TRefPlanType T9 ON T9.RefPlanTypeId = T8.RefPlanTypeId
	JOIN PolicyManagement..TCategoryPlanType T10 ON T10.RefPlanTypeId = T9.RefPlanTypeId
	JOIN PolicyManagement..TPlanCategory T11 ON T11.PlanCategoryId = T10.PlanCategoryId
	-- Provider Information
	JOIN PolicyManagement..TRefProdProvider T12 ON T12.RefProdProviderId = T7.RefProdProviderId
	JOIN CRM..TCRMContact T13 ON T13.CRMContactId = T12.CRMContactId		
	-- Client Information
	JOIN PolicyManagement..TPolicyOwner T14 ON T14.PolicyDetailId = T1.PolicyDetailId
	JOIN CRM..TCRMContact T15 ON T15.CRMContactId = T14.CRMContactId

-- Commissions FCI
INSERT INTO TKpi (
	ContactId,
	Contact,
	PastMonth,
	PastThreeMonths,
	PastSixMonths,
	PastYear,
	Type,
	Descriptor)
SELECT 
	T1.ContactId,
	T1.Contact,
	SUM(T1.PastMonth) As PastMonth,
	SUM(T1.PastThreeMonths) AS PastThreeMonths,
	SUM(T1.PastSixMonths) AS PastSixMonths,
	SUM(T1.PastYear) AS PastYear,
	5,
	'Commissions'
FROM
	(SELECT 
		'ContactId' = T1.CRMContactId,
		'Contact' = T2.FirstName + ' ' + T2.LastName,
		'PastMonth' = CASE WHEN T1.AllocatedDate >= DATEDIFF(mm, -1, GETDATE()) THEN T1.Amount ELSE 0 END,
		'PastThreeMonths' = CASE WHEN T1.AllocatedDate >= DATEDIFF(mm, -3, GETDATE()) THEN T1.Amount ELSE 0 END,
		'PastSixMonths' = 	CASE WHEN T1.AllocatedDate >= DATEDIFF(mm, -6, GETDATE()) THEN T1.Amount ELSE 0 END,
		'PastYear' = CASE WHEN T1.AllocatedDate >= DATEDIFF(yyyy, -1, GETDATE()) THEN T1.Amount ELSE 0 END
	FROM 
		Commissions..TPayment T1 
		JOIN CRM..TCRMContact T2 ON T2.CRMContactId = T1.CRMContactId
	WHERE T1.PolicyId IS NOT NULL
	) AS T1
GROUP BY T1.ContactId, T1.Contact

-- Fees FCI
INSERT INTO TKpi (
	ContactId,
	Contact,
	PastMonth,
	PastThreeMonths,
	PastSixMonths,
	PastYear,
	Type,
	Descriptor)
SELECT 
	T1.ContactId,
	T1.Contact,
	SUM(T1.PastMonth) As PastMonth,
	SUM(T1.PastThreeMonths) AS PastThreeMonths,
	SUM(T1.PastSixMonths) AS PastSixMonths,
	SUM(T1.PastYear) AS PastYear,
	5,
	'Fees'
FROM
	(SELECT 
		'ContactId' = T1.CRMContactId,
		'Contact' = T2.FirstName + ' ' + T2.LastName,
		'PastMonth' = 		CASE WHEN T1.AllocatedDate >= DATEDIFF(mm, -1, GETDATE()) THEN T1.Amount ELSE 0 END,
		'PastThreeMonths' = CASE WHEN T1.AllocatedDate >= DATEDIFF(mm, -3, GETDATE()) THEN T1.Amount ELSE 0 END,
		'PastSixMonths' = 	CASE WHEN T1.AllocatedDate >= DATEDIFF(mm, -6, GETDATE()) THEN T1.Amount ELSE 0 END,
		'PastYear' = 		CASE WHEN T1.AllocatedDate >= DATEDIFF(yyyy, -1, GETDATE()) THEN T1.Amount ELSE 0 END
	FROM 
		Commissions..TPayment T1 
		JOIN CRM..TCRMContact T2 ON T2.CRMContactId = T1.CRMContactId
	WHERE T1.FeeId IS NOT NULL
	) AS T1
GROUP BY T1.ContactId, T1.Contact

-- Retainer FCI
INSERT INTO TKpi (
	ContactId,
	Contact,
	PastMonth,
	PastThreeMonths,
	PastSixMonths,
	PastYear,
	Type,
	Descriptor)
SELECT 
	T1.ContactId,
	T1.Contact,
	SUM(T1.PastMonth) As PastMonth,
	SUM(T1.PastThreeMonths) AS PastThreeMonths,
	SUM(T1.PastSixMonths) AS PastSixMonths,
	SUM(T1.PastYear) AS PastYear,
	5,
	'Retainer'
FROM
	(SELECT 
		'ContactId' = T1.CRMContactId,
		'Contact' = T2.FirstName + ' ' + T2.LastName,
		'PastMonth' = 		CASE WHEN T1.AllocatedDate >= DATEDIFF(mm, -1, GETDATE()) THEN T1.Amount ELSE 0 END,
		'PastThreeMonths' = CASE WHEN T1.AllocatedDate >= DATEDIFF(mm, -3, GETDATE()) THEN T1.Amount ELSE 0 END,
		'PastSixMonths' = 	CASE WHEN T1.AllocatedDate >= DATEDIFF(mm, -6, GETDATE()) THEN T1.Amount ELSE 0 END,
		'PastYear' = 		CASE WHEN T1.AllocatedDate >= DATEDIFF(yyyy, -1, GETDATE()) THEN T1.Amount ELSE 0 END
	FROM 
		Commissions..TPayment T1
		JOIN CRM..TCRMContact T2 ON T2.CRMContactId = T1.CRMContactId
	WHERE T1.RetainerId IS NOT NULL
	) AS T1
GROUP BY T1.ContactId, T1.Contact

-- Persistance
INSERT INTO TKpi (
	ContactId,
	Contact,
	PastThreeMonths,
	PastSixMonths,
	PastYear,
	PastTwoYears,
	PastThreeYears,
	Type,
	Descriptor)
SELECT 
	T1.ContactId,
	T1.Contact,
	1 - (SUM(T1.PastThreeMonthsCancelled) / SUM(T1.PastThreeMonthsIssued)) AS PastThreeMonths,
	1 - (SUM(T1.PastSixMonthsCancelled) / SUM(T1.PastSixMonthsIssued)) AS PastSixMonths,
	1 - (SUM(T1.PastYearCancelled) / SUM(T1.PastYearIssued)) AS PastYear,
	1 - (SUM(T1.PastTwoYearsCancelled) / SUM(T1.PastTwoYearsIssued)) AS PastTwoYears,
	1 - (SUM(T1.PastThreeYearsCancelled) / SUM(T1.PastThreeYearsIssued)) AS PastThreeYears,
	6,
	'Persistance'
FROM
	(SELECT 
		'ContactId' = T5.CRMContactId,
		'Contact' = T5.FirstName + ' ' + T5.LastName,
		'PastThreeMonthsIssued' = 		CASE WHEN T4.ChangedToDate >= DATEDIFF(mm, -3, GETDATE()) AND T4.StatusId = 2 THEN 1 ELSE 0 END,
		'PastThreeMonthsCancelled' = 	CASE WHEN T4.ChangedToDate >= DATEDIFF(mm, -3, GETDATE()) AND T4.StatusId = 5 THEN 1 ELSE 0 END,
		'PastSixMonthsIssued' = 		CASE WHEN T4.ChangedToDate >= DATEDIFF(mm, -6, GETDATE()) AND T4.StatusId = 2 THEN 1 ELSE 0 END,
		'PastSixMonthsCancelled' = 		CASE WHEN T4.ChangedToDate >= DATEDIFF(mm, -6, GETDATE()) AND T4.StatusId = 5 THEN 1 ELSE 0 END,
		'PastYearIssued' = 				CASE WHEN T4.ChangedToDate >= DATEDIFF(yyyy, -1, GETDATE()) AND T4.StatusId = 2 THEN 1 ELSE 0 END,
		'PastYearCancelled' = 			CASE WHEN T4.ChangedToDate >= DATEDIFF(yyyy, -1, GETDATE()) AND T4.StatusId = 5 THEN 1 ELSE 0 END,
		'PastTwoYearsIssued' = 			CASE WHEN T4.ChangedToDate >= DATEDIFF(yyyy, -2, GETDATE()) AND T4.StatusId = 2 THEN 1 ELSE 0 END,
		'PastTwoYearsCancelled' = 		CASE WHEN T4.ChangedToDate >= DATEDIFF(yyyy, -2, GETDATE()) AND T4.StatusId = 5 THEN 1 ELSE 0 END,
		'PastThreeYearsIssued' = 		CASE WHEN T4.ChangedToDate >= DATEDIFF(yyyy, -3, GETDATE()) AND T4.StatusId = 2 THEN 1 ELSE 0 END,
		'PastThreeYearsCancelled' = 	CASE WHEN T4.ChangedToDate >= DATEDIFF(yyyy, -3, GETDATE()) AND T4.StatusId = 5 THEN 1 ELSE 0 END
	 FROM
		 PolicyManagement..TPolicyDetail T1
		 JOIN PolicyManagement..TPolicyBusiness T2 ON  T2.PolicyDetailId = T1.PolicyDetailId
		 JOIN CRM..TPractitioner T3 ON T3.PractitionerId = T2.PractitionerId
		 JOIN PolicyManagement..TStatusHistory T4 ON T4.PolicyBusinessId = T2.PolicyBusinessId
		 JOIN CRM..TCRMContact T5 ON T5.CRMContactId = T3.CRMContactId
	) AS T1
GROUP BY T1.ContactId, T1.Contact
HAVING SUM(T1.PastThreeMonthsIssued) > 0








GO
