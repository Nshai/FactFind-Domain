SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Teodora Pilitis
-- Create date: 24 Feb 2015
-- Description:	Returns all plans where a client is join applicant, filtered by plan category
-- =============================================
CREATE PROCEDURE [dbo].[nio_PS_GetPlansForJoinClient]
	-- Add the parameters for the stored procedure here
	@CrmContactId int,
	@TenantId int,
	@UseIsPlanVisibleToClientCheck bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	CREATE TABLE #JPlans
	(
		PlanId int,
		PrimaryCrmContactId int
	)

	CREATE TABLE #AllPlans
	(
		PlanId int,
		PolicyDetailId int,
		ParentPlanId int,
		IsTopUp bit,
		IsDeleted bit,
		PlanTypeId int
	)
	INSERT INTO
		#AllPlans
	SELECT 
		pb.PolicyBusinessId
		, pb.PolicyDetailId
		, null
		, 0
		, 0
		, null
	FROM 
		policymanagement..TPolicyBusiness pb WITH (NOLOCK)
	INNER JOIN
		policymanagement..TPolicyOwner pw WITH (NOLOCK) ON pw.PolicyDetailId = pb.PolicyDetailId
	JOIN 
		policymanagement..TPolicyBusinessExt s WITH (NOLOCK) ON s.PolicyBusinessId = pb.PolicyBusinessId
	WHERE 
		pw.CRMContactId = @CrmContactId and pb.IndigoClientId = @TenantId
		and (s.IsVisibleToClient = 1 OR @UseIsPlanVisibleToClientCheck = 0 )

	CREATE CLUSTERED INDEX IDX_C_AllPlans_PlanId ON #AllPlans(PlanId)

	INSERT INTO 
		#JPlans
	SELECT
		p.PlanId
		, min(po.CRMContactId)
	FROM
		policymanagement..TPolicyOwner po
	INNER JOIN
		#AllPlans p WITH (NOLOCK) on po.PolicyDetailId = p.PolicyDetailId
	GROUP BY
		p.PlanId
	HAVING
		COUNT(po.PolicyOwnerId) > 1

	-- get joint plans for that user
	CREATE TABLE #Plans
	(
		PlanId int,
		PolicyDetailId int,
		ParentPlanId int,
		IsTopUp bit,
		IsWrapper bit,
		IsDeleted bit,
		PlanTypeId int
	)
	INSERT INTO	
		#Plans
	SELECT 
		pb.PlanId
		, pb.PolicyDetailId
		, null
		, 0
		, 0
		, 0
		, null
	FROM 
		#AllPlans pb WITH (NOLOCK)
	INNER JOIN
		#JPlans jp WITH (NOLOCK) ON jp.PlanId = pb.PlanId
	-- for mortgages get if any additional owners
	UNION
	SELECT 
		pb.PolicyBusinessId
		, pb.PolicyDetailId
		, null
		, 0
		, 0
		, 0
		, null
	FROM 
		policymanagement..TPolicyBusiness pb WITH (NOLOCK)
	INNER JOIN
		policymanagement..TAdditionalOwner addOw WITH (NOLOCK) on pb.PolicyBusinessId = addOw.PolicyBusinessId
	JOIN policymanagement..TPolicyBusinessExt s WITH (NOLOCK)
		ON s.PolicyBusinessId = pb.PolicyBusinessId
	WHERE addOw.CRMContactId = @CrmContactId and pb.IndigoClientId = @TenantId
		and (s.IsVisibleToClient = 1 OR @UseIsPlanVisibleToClientCheck = 0 )
	
	-- get top ups only from the #Plans
	CREATE TABLE #TopUps
	(
		ParentPlanId int,
		PolicyDetailId int,
	)
	INSERT INTO
		#TopUps
	SELECT DISTINCT
		MIN(src.PlanId) AS ParentPlanId
		, PolicyDetailId
	FROM 
		#Plans src
	GROUP BY 
		PolicyDetailId
	HAVING
		Count(src.PlanId) > 1

	-- set parent plan Id for sub plans (wrappers)
	UPDATE 
		src
	SET 
		src.ParentPlanId = wrapper.ParentPolicyBusinessId
	FROM 
		#Plans src
	INNER JOIN
		policymanagement..TWrapperPolicyBusiness wrapper on src.PlanId = wrapper.PolicyBusinessId

		-- set id if (wrappers)
	UPDATE 
		src
	SET 
		src.IsWrapper= 1
	FROM 
		#Plans src
	INNER JOIN
		policymanagement..TWrapperPolicyBusiness wrapper on src.PlanId = wrapper.ParentPolicyBusinessId

	-- update IsTopUp flag and the parent planId for topups
	UPDATE 
		src
	SET 
		src.ParentPlanId = topUp.ParentPlanId
		, src.IsTopUp = 1
	FROM 
		#Plans src
	INNER JOIN
		#TopUps topUp on src.PolicyDetailId = topUp.PolicyDetailId
	where src.PlanId <> topUp.ParentPlanId

	-- mark deleted plans
	UPDATE
		src
	SET
		src.IsDeleted = 1
	FROM
		#Plans src
	INNER JOIN
		policymanagement..TStatusHistory sh on src.PlanId = sh.PolicyBusinessId and sh.CurrentStatusFG = 1
	INNER JOIN
		policymanagement..TStatus s on sh.StatusId = s.StatusId
	WHERE
		s.IndigoClientId = @TenantId and s.IntelligentOfficeStatusType = 'Deleted'

	-- get the planTypeId
	UPDATE
		src
	SET
		src.PlanTypeId = pdesc.RefPlanType2ProdSubTypeId
	FROM
		#Plans src
	INNER JOIN 
			policymanagement..TPolicyDetail pd WITH (NOLOCK) on src.PolicyDetailId = pd.PolicyDetailId
	INNER JOIN 
			policymanagement..TPlanDescription pdesc WITH (NOLOCK) on pd.PlanDescriptionId = pdesc.PlanDescriptionId

	SELECT 
		p.PlanId,
		p.PolicyDetailId,
		p.ParentPlanId,
		p.IsTopUp,
		p.IsWrapper,
		p.IsDeleted,
		p.PlanTypeId
	FROM 
		#Plans p
	WHERE
		p.IsDeleted = 0

	IF OBJECT_ID('tempdb..#Plans') IS NOT NULL
	  DROP TABLE #Plans 

	IF OBJECT_ID('tempdb..#TopUps') IS NOT NULL
	  DROP TABLE #TopUps

	IF OBJECT_ID('tempdb..#JPlans') IS NOT NULL
	  DROP TABLE #JPlans

	IF OBJECT_ID('tempdb..#AllPlans') IS NOT NULL
	  DROP TABLE #AllPlans
END
GO
