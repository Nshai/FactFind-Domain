SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Teodora Pilitis
-- Create date: 24 Feb 2015

-- Edit date: 31 May 2021
-- Edit details: #CrmContactIdNotOwnerPlans added

-- Description:	Gets all plans for a client, filtered by plan category, includes relatives as well.
-- Plans are filtered by IsDeleted status as well. Deleted plans are not shown.
-- =============================================
CREATE PROCEDURE [dbo].[nio_PS_GetAllPlansForClient]
	-- Add the parameters for the stored procedure here
	@CrmContactId INT,
	@TenantId INT,
	@UseIsPlanVisibleToClientCheck bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- get relatives for that client
	CREATE TABLE #Relatives
	(
	 CrmContactId INT
	)

	INSERT INTO
		#Relatives
	SELECT
		r.CRMContactToId
	FROM
		crm..TRelationship r
	WHERE
		r.CRMContactFromId = @CrmContactId and r.IncludeInPfp = 1
	CREATE CLUSTERED INDEX IDX_C_Relatives_CrmContactId ON #Relatives(CrmContactId)

	-- get all relative plans
	CREATE TABLE #RelativePlans
	(
		PlanId int,
		PolicyDetailId int,
		ParentPlanId int,
		IsTopUp bit,
		IsWrapper bit,
		IsDeleted bit,
		PlanTypeId int,
		PlanOwnerCRMContactId int
	)
	INSERT INTO
		#RelativePlans
	SELECT
		pb.PolicyBusinessId
		,pb.PolicyDetailId
		,null
		,0
		,0
		,0
		,null
		,pw.CRMContactId
	FROM
		policymanagement..TPolicyBusiness pb WITH (NOLOCK)
	INNER JOIN
		policymanagement..TPolicyOwner pw WITH (NOLOCK) on pw.PolicyDetailId = pb.PolicyDetailId
	INNER JOIN
		#Relatives rel on rel.CrmContactId = pw.CRMContactId and pb.IndigoClientId = @TenantId
	JOIN policymanagement..TPolicyBusinessExt s WITH (NOLOCK)
		ON s.PolicyBusinessId = pb.PolicyBusinessId
		and (s.IsVisibleToClient = 1 OR @UseIsPlanVisibleToClientCheck = 0 )

	-- now get only the sole relative plans
	CREATE TABLE #SoleRelativePlans
	(
		PlanId int,
		PrimaryCrmContactId int
	)

	INSERT INTO
		#SoleRelativePlans
	SELECT
		p.PlanId
		,MIN(po.CRMContactId)
	FROM
		policymanagement..TPolicyOwner po
	INNER JOIN
		#RelativePlans p on po.PolicyDetailId = p.PolicyDetailId
	GROUP BY
		p.PlanId
	HAVING
		COUNT(po.PolicyOwnerId) = 1
	CREATE CLUSTERED INDEX IDX_C_SolePlans_PlanId ON #SoleRelativePlans(PlanId)

-- plans where @CrmContactId is not owner but @CrmContactId can see them
	CREATE TABLE #CrmContactIdNotOwnerPlans
	(
		PlanId int,
		PrimaryCrmContactId int
	)

	INSERT INTO
		#CrmContactIdNotOwnerPlans
	SELECT
		p.PlanId
		,@CrmContactId
	FROM
		#RelativePlans p
	WHERE p.PlanOwnerCRMContactId <> @CrmContactId
	GROUP BY
		p.PlanId
	HAVING
		COUNT(p.PlanId) = 2
	CREATE CLUSTERED INDEX IDX_C_NotOwnerPlans_PlanId ON #CrmContactIdNotOwnerPlans(PlanId)

	-- get all plans incl relatives
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
		pb.PolicyBusinessId
		,pb.PolicyDetailId
		,null
		,0
		,0
		,0
		,null
	FROM
		policymanagement..TPolicyBusiness pb WITH (NOLOCK)
	INNER JOIN
		policymanagement..TPolicyOwner pw WITH (NOLOCK) on pw.PolicyDetailId = pb.PolicyDetailId
	JOIN policymanagement..TPolicyBusinessExt s WITH (NOLOCK)
		ON s.PolicyBusinessId = pb.PolicyBusinessId
	WHERE
		pw.CRMContactId = @CrmContactId and pb.IndigoClientId = @TenantId
		and (s.IsVisibleToClient = 1 OR @UseIsPlanVisibleToClientCheck = 0 )

	-- for mortgages get if any additional owners
	UNION
	SELECT
		pb.PolicyBusinessId
		,pb.PolicyDetailId
		,null
		,0
		,0
		,0
		,null
	FROM
		policymanagement..TPolicyBusiness pb WITH (NOLOCK)
	INNER JOIN
		policymanagement..TAdditionalOwner addOw WITH (NOLOCK) on pb.PolicyBusinessId = addOw.PolicyBusinessId
	JOIN policymanagement..TPolicyBusinessExt s WITH (NOLOCK)
		ON s.PolicyBusinessId = pb.PolicyBusinessId
	WHERE addOw.CRMContactId = @CrmContactId and pb.IndigoClientId = @TenantId
		and (s.IsVisibleToClient = 1 OR @UseIsPlanVisibleToClientCheck = 0 )

	-- get sole relatives plans
	UNION
	SELECT
		pb.PlanId,
		pb.PolicyDetailId,
		pb.ParentPlanId,
		pb.IsTopUp,
		pb.IsWrapper,
		pb.IsDeleted,
		pb.PlanTypeId
	FROM
		#RelativePlans pb
	INNER JOIN
		#SoleRelativePlans srp on pb.PlanId = srp.PlanId

	-- get plans where @CRMContactId is not owner but can see them
	UNION
	SELECT
		pb.PlanId,
		pb.PolicyDetailId,
		pb.ParentPlanId,
		pb.IsTopUp,
		pb.IsWrapper,
		pb.IsDeleted,
		pb.PlanTypeId
	FROM
		#RelativePlans pb
	INNER JOIN
		#CrmContactIdNotOwnerPlans rnop on pb.PlanId = rnop.PlanId

	UNION
	SELECT
		pb.PolicyBusinessId
		,pb.PolicyDetailId
		,null
		,0
		,0
		,0
		,null
	FROM
		policymanagement..TPolicyBusiness pb WITH (NOLOCK)
	INNER JOIN
		policymanagement..TAdditionalOwner addOw WITH (NOLOCK) on pb.PolicyBusinessId = addOw.PolicyBusinessId
	INNER JOIN
		#Relatives rel on rel.CrmContactId = addOw.CrmContactId and pb.IndigoClientId = @TenantId
	JOIN policymanagement..TPolicyBusinessExt s WITH (NOLOCK)
		ON s.PolicyBusinessId = pb.PolicyBusinessId
		and (s.IsVisibleToClient = 1 OR @UseIsPlanVisibleToClientCheck = 0 )
	CREATE CLUSTERED INDEX IDX_C_Plans_PolicyBusinessId ON #Plans(PlanId)

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
		,PolicyDetailId
	FROM
		#Plans src
	GROUP BY
		PolicyDetailId
	HAVING
		Count(src.PlanId) > 1
	-- SELECT * FROM #TopUps


	-- set parent plan Id for sub plans (wrappers)
	UPDATE
		src
	SET
		src.ParentPlanId = wrapper.ParentPolicyBusinessId
	FROM
		#Plans src
	INNER JOIN
		policymanagement..TWrapperPolicyBusiness wrapper on src.PlanId = wrapper.PolicyBusinessId


	-- set parent plan Id for sub plans (wrappers)
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
		,src.IsTopUp = 1
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

	IF OBJECT_ID('tempdb..#Relatives') IS NOT NULL
	DROP TABLE #Relatives

	IF OBJECT_ID('tempdb..#SoleRelativePlans') IS NOT NULL
	DROP TABLE #SoleRelativePlans

	IF OBJECT_ID('tempdb..#CrmContactIdNotOwnerPlans') IS NOT NULL
	DROP TABLE #CrmContactIdNotOwnerPlans

	IF OBJECT_ID('tempdb..#RelativePlans') IS NOT NULL
	DROP TABLE #RelativePlans

	IF OBJECT_ID('tempdb..#TopUps') IS NOT NULL
	DROP TABLE #TopUps
END
GO
