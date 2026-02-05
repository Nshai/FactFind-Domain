SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE dbo.SpCustomValuationsUpdateValEligibilityMask
	@PolicyBusinessIds dbo.PolicyBusinessIdListType READONLY
AS
BEGIN
	--------------------------------------------------------------------------
	-- Notes
	-- 
	-- 30 Apr 2014	This sp is based on Reports.dbo.SpUpdateValEligibilityMask
	--				This updates TValPotentialPlan

	SET NOCOUNT ON
	SET XACT_ABORT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    DECLARE 
        @HASPOLICYNUMBER TINYINT = 1,
        @VALIDPLANSTATUS TINYINT = 2, 
        @VALIDADVISERSTATUS TINYINT = 4,
        @PLANINCLUDED TINYINT = 8, 
        @VALIDPLANTYPE TINYINT = 16,
        @PLANNOTATOPUP TINYINT = 32, 
        @PLANNOTASUBPLAN TINYINT = 64

	DECLARE @ActionUser VARCHAR(1) = '0'

	IF object_id('tempdb..#tmpTValPotentialPlan') is not null 
		drop table #tmpTValPotentialPlan

	select 
		pp.ValPotentialPlanId, pp.ValuationProviderId, pp.PolicyProviderId, pp.PolicyProviderName, pp.IndigoClientId, 
		pp.PolicyBusinessId, pp.SequentialRef, pp.PolicyDetailId, pp.PolicyNumber, pp.FormattedPolicyNumber, pp.PortalReference, 
		pp.FormattedPortalReference, pp.AgencyNumber, pp.RefPlanType2ProdSubTypeId, pp.ProviderPlanType, 
		pp.NINumber, pp.DOB, pp.LastName, pp.Postcode, pp.PolicyStatusId, pp.PolicyStartDate, pp.PolicyOwnerCRMContactID, 
		pp.SellingAdviserCRMContactID, pp.SellingAdviserStatus, pp.ServicingAdviserCRMContactID, pp.ServicingAdviserStatus, 
		pp.IsExcluded, pp.IsTopup, 0 as EligibilityMask, pp.EligibilityMaskRequiresUpdating, pp.ConcurrencyId 
	into #tmpTValPotentialPlan
	from TValPotentialPlan PP with (nolock)
		join @PolicyBusinessIds pb on pp.PolicyBusinessId = pb.PolicyBusinessId
	where pp.EligibilityMaskRequiresUpdating = 1

	--Policy Number
    UPDATE #tmpTValPotentialPlan
	SET EligibilityMask = EligibilityMask + @HASPOLICYNUMBER
    WHERE LEN(PolicyNumber) > 0

	-- NOTE: This is safety net - ideally all plans in TValPotentialPlan would be either In force or Paid Up
    UPDATE PP 
	SET EligibilityMask = EligibilityMask + @VALIDPLANSTATUS
    FROM #tmpTValPotentialPlan PP 
    INNER JOIN dbo.TStatus ST WITH(NOLOCK) On ST.StatusId = PP.PolicyStatusId
    WHERE ST.IntelligentOfficeStatusType IN ('In force', 'Paid Up')

	--Selling Adviser
    UPDATE #tmpTValPotentialPlan 
	SET EligibilityMask = EligibilityMask + @VALIDADVISERSTATUS
    WHERE (SellingAdviserStatus like 'Access Granted%') OR (ServicingAdviserStatus like 'Access Granted%')

	-- Set the PlanIncluded bit for all plans that have NOT been excluded from valuations, either manually by a user OR by the system
    UPDATE #tmpTValPotentialPlan 
	SET EligibilityMask = EligibilityMask + @PLANINCLUDED
	WHERE IsExcluded = 0

	--============================================
	-- Set the NotASubPlan bit for relevant plans.
	--============================================
	-- For the time being this flag is not used.
	--============================================
    -- UPDATE 
	-- 	PP 
	-- SET 
	-- 	EligibilityMask = EligibilityMask + @PLANNOTASUBPLAN
    -- FROM
	-- 	[TValPotentialPlan] PP WITH (NOLOCK)
	-- 	LEFT JOIN dbo.TWrapperPolicyBusiness WP WITH (NOLOCK) ON PP.PolicyBusinessId = WP.PolicyBusinessId
    -- WHERE
	-- 	[EligibilityMaskRequiresUpdating] = 1 
	-- 	AND WP.PolicyBusinessId IS NOT NULL

	-- Set the ValidPlanType bit for all plans that are of a RefPlanType for which valuations are currently supported for the provider.
    UPDATE PP 
	SET EligibilityMask = EligibilityMask + @VALIDPLANTYPE
    FROM #tmpTValPotentialPlan PP WITH (NOLOCK)  
        JOIN dbo.TRefPlanType2ProdSubType PT WITH(NOLOCK) ON PP.RefPlanType2ProdSubTypeId = PT.RefPlanType2ProdSubTypeId
        JOIN dbo.TValGating VG WITH (NOLOCK) ON PP.ValuationProviderId = VG.RefProdproviderid 
    WHERE 1=1
		AND PT.RefPlanTypeId = VG.RefPlanTypeID 
		AND ISNULL(PT.ProdSubTypeId,0) = ISNULL(VG.ProdSubTypeID,0)

	--Not a top up
    UPDATE #tmpTValPotentialPlan 
	SET EligibilityMask = EligibilityMask + @PLANNOTATOPUP
	WHERE IsTopup = 0
	
	CREATE NONCLUSTERED INDEX [IX_tmpTValPotentialPlan] ON #tmpTValPotentialPlan (valpotentialplanid)

	-- Reset the Mask and the flag
	while exists (select top 1 1 from TValPotentialPlan PP with (nolock) join #tmpTValPotentialPlan TP with (nolock) on pp.valpotentialplanid = tp.valpotentialplanid where PP.[EligibilityMaskRequiresUpdating] = 1)
	begin 

		UPDATE top (50000) PP 
		SET [EligibilityMaskRequiresUpdating] = 0, pp.EligibilityMask = tp.EligibilityMask
		FROM [TValPotentialPlan] PP
			JOIN #tmpTValPotentialPlan TP on pp.ValPotentialPlanId = tp.ValPotentialPlanId
		where pp.EligibilityMaskRequiresUpdating = 1

	end

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET XACT_ABORT OFF

END
GO