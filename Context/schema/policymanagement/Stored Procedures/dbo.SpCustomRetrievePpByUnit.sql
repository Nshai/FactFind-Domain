SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrievePpByUnit]
	@PlanCategoryId bigint = 0,
	@PlanTypeId bigint = 0,
	@StartDate varchar(20) = '',
	@EndDate varchar(20) = '',
	@Submitted tinyint = 0, 
	@IndigoClientId int = 0
AS

SET NOCOUNT ON

-- Declarations
DECLARE @PlanCategory varchar(255), 
		@PlanType varchar(255), 
		@StartDatetime datetime, 
		@EndDatetime datetime,
		@SubmittedStatus bigint,
		@IssuedStatus bigint

-- Get Category Name
SELECT	@PlanCategory = T1.PlanCategoryName
FROM	PolicyManagement..TPlanCategory T1 
WHERE	T1.PlanCategoryId = @PlanCategoryId

-- Get Category Type
IF @PlanTypeId = 0
	SELECT @PlanType = 'All'
ELSE
	SELECT	@PlanType = T1.PlanTypeName
	FROM	PolicyManagement..TRefPlanType T1 
	WHERE	T1.RefPlanTypeId = @PlanTypeId

-- Sort out start and end dates
IF @StartDate = ''
	SELECT @StartDate = 'Not Specified', @StartDatetime = NULL
ELSE
	SELECT @EndDatetime = CONVERT(datetime, @StartDate, 100)

IF @EndDate = ''
	SELECT @EndDate = 'Not Specified', @EndDatetime = NULL
ELSE
	SELECT @EndDatetime = CONVERT(datetime, @EndDate, 100)

-- Get data for the report
SELECT 	
	1 AS Tag,
	NULL AS Parent,
	@PlanCategory AS [Report!1!PlanCategory],
	@PlanType AS [Report!1!PlanType],
	@StartDate AS [Report!1!StartDate],
	@EndDate AS [Report!1!EndDate],
	T7.CorporateName AS [Report!1!Provider],
	COUNT(T7.CorporateName) AS [Report!1!Cases],
	ISNULL(SUM(T8.Amount), 0) AS [Report!1!Amount],
	T13.Identifier AS [Report!1!Group],
	T14.Identifier AS [Report!1!GroupName]
FROM
	PolicyManagement..TPolicyDetail T1
	-- Plan Type
	LEFT JOIN PolicyManagement..TPlanDescription T2 ON T2.PlanDescriptionId = T1.PlanDescriptionId
	LEFT JOIN PolicyManagement..TRefPlanType2ProdSubType T3 ON T3.RefPlanType2ProdSubTypeId = T2.RefPlanType2ProdSubTypeId
	LEFT JOIN PolicyManagement..TRefPlanType T4 ON T4.RefPlanTypeId = T3.RefPlanTypeId
	LEFT JOIN PolicyManagement..TCategoryPlanType T5 ON T5.RefPlanTypeId = T4.RefPlanTypeId
	-- Provider					 
	LEFT JOIN PolicyManagement..TRefProdProvider T6 ON T6.RefProdProviderId = T2.RefProdProviderId
	LEFT JOIN CRM..TCRMContact T7 ON T7.CRMContactId = T6.CRMContactId
	-- FCI
	LEFT JOIN Commissions..TPayment T8 ON T8.PolicyId = T1.PolicyDetailId
	-- Organisational Unit
	LEFT JOIN PolicyManagement..TPolicyBusiness T9 ON T9.PolicyDetailId = T1.PolicyDetailId
	LEFT JOIN CRM..TPractitioner T10 ON T10.PractitionerId = T9.PractitionerId
	LEFT JOIN CRM..TCRMContact T11 ON T11.CRMContactId = T10.CRMContactId
	LEFT JOIN Administration..TUser T12 ON T12.CRMContactId = T11.CRMContactId
	LEFT JOIN Administration..TGroup T13 ON T13.GroupId = T12.GroupId
	LEFT JOIN Administration..TGrouping T14 ON T14.GroupingId = T13.GroupingId
	-- Submitted or Issued
	LEFT JOIN PolicyManagement..TPolicyBusiness T15 ON T15.PolicyDetailId = T1.PolicyDetailId
	LEFT JOIN TStatusHistory T16 ON T16.PolicyBusinessId = T15.PolicyBusinessId
WHERE
	(T5.PlanCategoryId = @PlanCategoryId OR @PlanCategoryId = 0) AND
	(T4.RefPlanTypeId = @PlanTypeId OR @PlanTypeId = 0) AND
  	((T8.AllocatedDate >= @StartDatetime OR @StartDatetime IS NULL) AND
	(T8.AllocatedDate <= @EndDatetime OR @EndDatetime IS NULL)) AND
	(T12.IndigoClientId = @IndigoClientId OR @IndigoClientId = 0)

GROUP BY T13.Identifier, T14.Identifier, T7.CorporateName

FOR XML EXPLICIT

RETURN (0)









GO
