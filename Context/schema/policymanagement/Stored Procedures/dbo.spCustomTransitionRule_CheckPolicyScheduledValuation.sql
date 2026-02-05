SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckPolicyScheduledValuation]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
AS


BEGIN

	DECLARE @PolicyOwnerCrmId INT, @AdviserSchedule BIT, @ClientSchedule BIT

	--Retrieve the policy details
	SELECT @PolicyOwnerCrmId = MIN(CRMContactId) 
	FROM TPolicyOwner own 
	JOIN TPolicyBusiness pb ON own.PolicyDetailId = pb.PolicyDetailId 
	WHERE pb.PolicyBusinessId = @policyBusinessid

	IF OBJECT_ID('tempdb..#policyattributes') is not null 
	BEGIN 
		DROP TABLE #policyattributes
	END

	SELECT	PB.IndigoClientId, de.RefProdProviderId PolicyProviderId, PB.PolicyBusinessId, de.RefPlanType2ProdSubTypeId, PB.PractitionerId, NULL ValuationProviderId, 
			own.CRMContactId PolicyOwnerCRMContactId, selUsr.CRMContactId SellingAdviserCRMContactID,
		CASE
			WHEN selUsr.Status LIKE 'Access Granted%' THEN 'Access Granted' 
			WHEN selUsr.Status LIKE 'Access Denied%' THEN 'Access Denied' 
			ELSE selUsr.Status 
		END SellingAdviserStatus
		,own.CurrentAdviserCRMId ServicingAdviserCRMContactID,
		CASE
			WHEN serAdv.Status  LIKE 'Access Granted%' THEN 'Access Granted' 
			WHEN serAdv.Status  LIKE 'Access Denied%' THEN 'Access Denied' 
			ELSE serAdv.Status 
		END ServicingAdviserStatus
	INTO #policyattributes 
	FROM TPolicyBusiness pb 
		JOIN TPolicyDetail pd ON pb.PolicyDetailId = pd.PolicyDetailId
		JOIN TPlanDescription de ON pd.PlanDescriptionId = de.PlanDescriptionId
		--Selling Adviser
		JOIN crm..TPractitioner selAdv ON selAdv.PractitionerId = pb.PractitionerId JOIN administration..tuser selUsr ON selUsr.CRMContactId = selAdv.CRMContactId
		--Servicing Adviser
		JOIN crm..TCRMContact own ON own.crmcontactid = @PolicyOwnerCrmId JOIN crm..TCRMContact owncrm ON own.CRMContactId = owncrm.CRMContactId JOIN administration..TUser serAdv ON owncrm.CurrentAdviserCRMId = serAdv.CRMContactId
	WHERE pb.PolicyBusinessId = @policyBusinessid

	--find valuation provider
	IF OBJECT_ID('tempdb..#providers') IS NOT NULL 
	BEGIN 
		DROP TABLE  #providers
	END

		SELECT refprodproviderid as valuationproviderid, RefProdProviderId PolicyProviderId 
		INTO #providers 
		FROM tvalproviderconfig c 
			JOIN #policyattributes a ON c.RefProdProviderId = a.PolicyProviderId

		UNION

		SELECT MappedRefProdProviderId as valuationproviderid, RefProdProviderId PolicyProviderId 
		FROM tvallookup l 
			JOIN #policyattributes a ON l.RefProdProviderId = a.PolicyProviderId

	UPDATE t SET ValuationProviderId = p.valuationproviderid 
	FROM #policyattributes t 
		JOIN #providers p ON t.PolicyProviderId = p.PolicyProviderId
	
	IF @@ROWCOUNT < 1  
	BEGIN
		--'Provider is not supported for valuation'
		RETURN
	END	

	
	IF NOT EXISTS(SELECT 1 FROM TValProviderConfig pc JOIN #policyattributes a on pc.refprodproviderid = a.ValuationProviderId WHERE SupportedService & 8 = 8 )
	BEGIN
		--'Provider doesnot support real time scheduled valuation'
		RETURN
	END

	--check if plantype is supported
	DECLARE @RefPlanType2ProdSubTypeId INT, @ValuationProviderid INT
	IF EXISTS (SELECT 1 FROM #policyattributes pa join TWrapperPolicyBusiness wrapper ON pa.PolicyBusinessId = wrapper.PolicyBusinessId)
	BEGIN 
		SELECT @RefPlanType2ProdSubTypeId = de.RefPlanType2ProdSubTypeId, @ValuationProviderid = pa.ValuationProviderId
		FROM #policyattributes pa 
			JOIN TWrapperPolicyBusiness wrapper on pa.PolicyBusinessId = wrapper.PolicyBusinessId
			JOIN TPolicyBusiness pb ON pb.PolicyBusinessId = wrapper.ParentPolicyBusinessId
			JOIN TPolicyDetail pd ON pb.PolicyDetailId = pd.PolicyDetailId
			JOIN TPlanDescription de ON pd.PlanDescriptionId = de.PlanDescriptionId
	END
	ELSE
	BEGIN
		SELECT @RefPlanType2ProdSubTypeId = RefPlanType2ProdSubTypeId, @ValuationProviderid = ValuationProviderId FROM #policyattributes
	END

	IF NOT EXISTS( SELECT 1 FROM TRefPlanType2ProdSubType rpps 
									LEFT JOIN TValGating Gating ON rpps.RefPlanTypeId = Gating.RefPlanTypeId
									AND ISNULL(rpps.ProdSubTypeId,'') = ISNULL(Gating.ProdSubTypeId,'')
							WHERE rpps.RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId AND GATING.RefProdProviderId = @ValuationProviderid)
	BEGIN
		--plan type not supported for valuation
		RETURN
	END

	--Client Schedule
	IF EXISTS (SELECT 1 FROM #policyattributes pa JOIN TValSchedulePolicy sp ON pa.PolicyBusinessId = sp.PolicyBusinessId) 
	BEGIN
		-- client Schedule Exists
		RETURN
	END

	--Adviser Shedule
	IF EXISTS (SELECT 1 FROM #policyattributes pa JOIN TValSchedule s ON pa.ValuationProviderId = s.RefProdProviderId AND  S.IndigoClientId = pa.IndigoClientId
												AND 
												(
													(
													(S.PortalCRMContactId = pa.SellingAdviserCRMContactID AND pa.SellingAdviserStatus = 'Access Granted') 
													OR
													(pa.SellingAdviserStatus != 'Access Granted'  AND pa.ServicingAdviserStatus = 'Access Granted' AND S.PortalCRMContactId =  pa.ServicingAdviserCRMContactID)
													)
												)
	)
	BEGIN
		-- Adviser Schedule Exists
		RETURN
	END



	--Provider and Plan Type supports RT valuation, but no Client or Adviser schedule Exists
	SELECT @ErrorMessage = 'SCHEDULEDVALUATION'



	--Drop Temp Tables
	IF OBJECT_ID('tempdb..#providers') IS NOT NULL 
	BEGIN 
		DROP TABLE  #providers
	END

	IF OBJECT_ID('tempdb..#policyattributes') is not null 
	BEGIN 
		DROP TABLE #policyattributes
	END

END



GO
