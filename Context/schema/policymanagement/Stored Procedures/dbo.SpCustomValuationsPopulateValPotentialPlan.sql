
CREATE PROCEDURE dbo.SpCustomValuationsPopulateValPotentialPlan
	@PolicyBusinessIds dbo.PolicyBusinessIdListType READONLY
As
BEGIN
	--------------------------------------------------------------------------
	-- Notes
	-- 
	-- 22 Apr 2014	This sp is based on Reports.dbo.SpPopulateValPotentialPlan
	--				This updates TValPotentialPlan
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET XACT_ABORT ON

    DECLARE @ActionTime DATETIME = GETDATE(), @ActionUser VARCHAR(1) = '0', @ErrorMessage VARCHAR(MAX)
	DECLARE @BulkManualTemplate BIGINT
	DECLARE @CLEANUP_LEADINGZEROS_PLANNUMBER TINYINT = 1, @CLEANUP_SPACE_PLANNUMBER TINYINT = 2, @FORMAT_FIDELITY_TAXYEARPLAN TINYINT = 4

	SELECT @BulkManualTemplate = rp.RefProdProviderId 
	from TRefProdProvider rp 
	join crm..tcrmcontact c on rp.crmcontactid = c.CRMContactId
	where c.Corporatename like 'Bulk Manual Template'

	IF OBJECT_ID('TEMPDB..#SetupProviders') IS NOT NULL 
		DROP TABLE #SetupProviders

    SELECT RefProdProviderId as ValuationProviderId, RefProdProviderId as PolicyProviderId
	INTO #SetupProviders
	FROM TValProviderConfig

	UNION

	SELECT pc.RefProdProviderId as ValuationProviderId, LKP.RefProdProviderId as PolicyProviderId
	FROM TValProviderConfig PC  
	JOIN TValLookUp LKP ON PC.RefProdProviderId = LKP.MappedRefProdProviderId

	IF OBJECT_ID('TEMPDB..#EligibleProviders') IS NOT NULL 
		DROP TABLE #EligibleProviders
	select ValuationProviderId, PolicyProviderId 
	into #EligibleProviders
	from #SetupProviders

	union

	select @BulkManualTemplate, RefProdProviderId 
	from TValTemplateProvider
	where not exists (select 1 from #SetupProviders where PolicyProviderId = refprodproviderid )


	-- Filter PolicyBusinessIds, should only use ids for not obfuscated clients
	DECLARE @PoliciesIdsToUse dbo.PolicyBusinessIdListType;

	INSERT INTO @PoliciesIdsToUse
	SELECT DISTINCT PIDS.PolicyBusinessId
	FROM @PolicyBusinessIds PIDS
	JOIN TPolicyBusiness PB ON PB.PolicyBusinessId = PIDS.PolicyBusinessId
	JOIN TPolicyDetail Detail ON PB.PolicyDetailId = Detail.PolicyDetailId
	JOIN TPolicyOwner PO ON PO.PolicyDetailId = Detail.PolicyDetailId
	JOIN crm..TCRMContact CC ON CC.CrmContactId = PO.CRMContactId
	WHERE CC.IsDeleted = 0


	IF OBJECT_ID('TEMPDB..#Policies') IS NOT NULL 
		DROP TABLE #Policies

	select  
			ValuationProviderId
			,PB.IndigoClientId
			,Policy.RefProdProviderId PolicyProviderId
			,PB.PolicyBusinessId
			,PB.SequentialRef
			,Case when x.PolicyBusinessid is null then 0 else 1 end IsExcluded
			,Case when pb.TopupMasterPolicyBusinessId is null then 0 else 1 end IsTopup
			,PB.PolicyDetailId
			,PB.PolicyNumber
			,PB.PolicyStartDate	
			,Ext.PortalReference
			,CurrentStatus.StatusId PlanStatusId 
			,Policy.RefPlanType2ProdSubTypeId
			,PB.PractitionerId
			,RP.RefPlanTypeId
			,RP.ProdSubTypeId
		into #Policies
		from TPolicyBusiness PB  
		JOIN TPolicyDetail Detail On PB.PolicyDetailId = Detail.PolicyDetailId
		JOIN TPlanDescription Policy On Detail.PlanDescriptionId = Policy.PlanDescriptionId
		JOIN #EligibleProviders Providers ON Policy.RefProdproviderID = Providers.PolicyProviderId
		JOIN TPolicyBusinessExt Ext ON PB.PolicyBusinessId = Ext.PolicyBusinessId
		JOIN TStatusHistory CurrentStatus On PB.PolicyBusinessId = CurrentStatus.PolicyBusinessId AND CurrentStatus.CurrentStatusFG = 1
		JOIN TStatus PStatus On CurrentStatus.StatusId = PStatus.StatusId
		JOIN TRefPlanType2ProdSubType RP  ON RP.RefPlanType2ProdSubTypeId = Policy.RefPlanType2ProdSubTypeId
		Join @PoliciesIdsToUse pbids on pb.PolicyBusinessId = pbids.PolicyBusinessId
		left join TValExcludedPlan X on pb.PolicyBusinessId = X.PolicyBusinessId
		where 1=1
		AND PStatus.IntelligentOfficeStatusType IN ('In force', 'Paid Up')


	IF OBJECT_ID('TEMPDB..#PolicyOwner') IS NOT NULL 
		DROP TABLE #PolicyOwner

	Select PolicyBusinessId, Min(PolicyOwnerId) as PolicyOwnerId
	Into #PolicyOwner
	From #Policies a 
	Join TPolicyOwner b on a.PolicyDetailId = b.PolicyDetailId
	Group by PolicyBusinessId


	IF OBJECT_ID('TEMPDB..#Address') IS NOT NULL 
		DROP TABLE #Address

	Select a.PolicyBusinessId, Min(e.AddressStoreId) as AddressStoreId
	Into #Address
	From #Policies a 
	Join #PolicyOwner b on a.PolicyBusinessId = b.PolicyBusinessId
	Join TPolicyOwner c on b.PolicyOwnerId = c.PolicyOwnerId
	Join crm..TAddress d on c.CRMContactId = d.CRMContactId and d.RefAddressStatusId = 1 and d.DefaultFg = 1
	Join crm..TAddressStore e on d.AddressStoreId = e.AddressStoreId
	Group by a.PolicyBusinessId

	IF OBJECT_ID('TEMPDB..#TValPotentialPlan') IS NOT NULL 
			DROP TABLE #TValPotentialPlan

	SELECT ValuationProviderId
	,P.PolicyProviderId 
	,PolicyProvider.CorporateName as PolicyProviderName
	,P.IndigoClientId
	,P.PolicyBusinessId
	,P.SequentialRef
	,p.IsExcluded
	,p.IsTopup
	,P.PolicyDetailId
	,P.PolicyNumber
	,CAST(P.PolicyNumber AS varchar(60)) AS FormattedPolicyNumber
	,p.PortalReference
	,P.RefPlanType2ProdSubTypeId
	,Gating.ProviderPlanTypeName ProviderPlanType
	,Person.NINumber
	,Person.DOB
	,Person.LastName
	,AddStore.Postcode
	,P.PlanStatusId
	,P.PolicyStartDate
	,policyowner.CRMContactId PolicyOwnerCRM
	,sellingAdviser.CRMContactId SellingCRM,
	Case
		when sellingUser.Status like 'Access Granted%' then 'Access Granted' 
		when sellingUser.Status like 'Access Denied%' then 'Access Denied' 
		Else sellingUser.Status 
		End SellingAdviserStatus
	,policyowner.CurrentAdviserCRMId ServicingCRM, 
	Case
		when ServicingUser.Status  like 'Access Granted%' then 'Access Granted' 
		when ServicingUser.Status  like 'Access Denied%' then 'Access Denied' 
		Else ServicingUser.Status 
		End ServicingAdviserStatus
	INTO #TValPotentialPlan
	FROM #Policies P
		--Selling Adviser
		JOIN crm..TPractitioner sellingAdviser On P.PractitionerId = sellingAdviser.PractitionerId 
		JOIN administration..tuser sellingUser On sellingAdviser.CRMContactId = sellingUser.CRMContactId
		--Owner
		Join #PolicyOwner own on p.PolicyBusinessId = own.PolicyBusinessId
		JOIN TPolicyOwner LookUpOwner On P.PolicyDetailId = LookUpOwner.PolicyDetailId
			And own.PolicyOwnerId = LookUpOwner.PolicyOwnerId 
		JOIN crm..TCRMContact policyowner ON LookUpOwner.CRMContactId = Policyowner.CRMContactId
		--Servicing Adviser
		INNER JOIN administration..TUser ServicingUser On policyowner.CurrentAdviserCRMId = ServicingUser.CRMContactId
		--Policy Provider details
		INNER JOIN TRefProdProvider RPP ON RPP.RefProdProviderID = P.PolicyProviderId
		INNER JOIN crm..TCRMContact PolicyProvider ON RPP.CrmContactId = PolicyProvider.CrmContactId
		--Owner Details
		LEFT JOIN crm..TPerson Person On policyOwner.PersonId = Person.PersonId
		Left Join #Address Addres on p.PolicyBusinessId = Addres.PolicyBusinessId
		LEFT JOIN crm..TAddressStore AddStore On Addres.AddressStoreId = AddStore.AddressStoreId
		--Wrapper details
		LEFT JOIN TwrapperPolicyBusiness wrapper On P.PolicyBusinessId = wrapper.policyBusinessID
		--Provider Plan type name
		LEFT JOIN TValGating Gating ON P.RefPlanTypeId = Gating.RefPlanTypeId
			AND ISNULL(P.ProdSubTypeId,'') = ISNULL(Gating.ProdSubTypeId,'')
			AND GATING.RefProdProviderId = ValuationProviderId



	Declare @sqltext0 nvarchar(max)

	select @sqltext0 = '
	UPDATE PP
	SET [FormattedPolicyNumber] = RTRIM(
										SUBSTRING(
													LTRIM([FormattedPolicyNumber]), 
													PATINDEX(''%[^0]%'', LTRIM([FormattedPolicyNumber])),
													LEN(LTRIM([FormattedPolicyNumber]))
													)
										)
	FROM #TValPotentialPlan PP 
	Join TValMatchingCriteria MC on PP.ValuationProviderId = MC.ValuationProviderId AND MC.MatchingMask & ' + 
				convert(varchar,@CLEANUP_LEADINGZEROS_PLANNUMBER) + ' = ' + convert(varchar,@CLEANUP_LEADINGZEROS_PLANNUMBER) + '
			Join @PolicyBusinessIds a on pp.PolicyBusinessId = a.PolicyBusinessId'
			exec sp_executesql @sqltext0, N'@PolicyBusinessIds dbo.PolicyBusinessIdListType READONLY', @PolicyBusinessIds = @PoliciesIdsToUse

	select @sqltext0 = '
	UPDATE PP
	SET [FormattedPolicyNumber] = REPLACE([FormattedPolicyNumber],  '' '', '''')
	FROM #TValPotentialPlan PP 
	Join TValMatchingCriteria MC on PP.ValuationProviderId = MC.ValuationProviderId AND MC.MatchingMask & ' + 
				convert(varchar,@CLEANUP_SPACE_PLANNUMBER) + ' = ' + convert(varchar,@CLEANUP_SPACE_PLANNUMBER) + '
			Join @PolicyBusinessIds a on pp.PolicyBusinessId = a.PolicyBusinessId'
			exec sp_executesql @sqltext0, N'@PolicyBusinessIds dbo.PolicyBusinessIdListType READONLY', @PolicyBusinessIds = @PoliciesIdsToUse

	IF OBJECT_ID('TEMPDB..#ExistingRecordCheckSum') IS NOT NULL 
			DROP TABLE #ExistingRecordCheckSum

	IF OBJECT_ID('TEMPDB..#NewRecordCheckSum') IS NOT NULL 
			DROP TABLE #NewRecordCheckSum
	
	IF OBJECT_ID('TEMPDB..#ExistingValPotentialPlan') IS NOT NULL 
			DROP TABLE #ExistingValPotentialPlan


	Select A.PolicyBusinessId, 
		A.ValuationProviderId, A.PolicyProviderId, A.PolicyProviderName,
		A.IndigoClientId, A.PolicyDetailId, A.PolicyNumber, A.FormattedPolicyNumber,
		A.PortalReference, 
		A.RefPlanType2ProdSubTypeId, A.ProviderPlanType,
		A.NINumber, A.DOB, A.LastName, 
		A.Postcode, A.PolicyStatusId, A.PolicyStartDate,
		A.PolicyOwnerCRMContactID, A.SellingAdviserCRMContactID, A.SellingAdviserStatus,
		A.ServicingAdviserCRMContactID, A.ServicingAdviserStatus
		,A.SequentialRef, A.IsExcluded,A.IsTopup
	Into #ExistingValPotentialPlan
	From TValPotentialPlan a
			Join @PoliciesIdsToUse pbids on a.PolicyBusinessId = pbids.PolicyBusinessId


	declare @ExistingNumberOfPolicies bigint, @NewNumberOfPolicies bigint

	Select a.PolicyBusinessId, 
		BINARY_CHECKSUM(
			A.ValuationProviderId, A.PolicyProviderId, A.PolicyProviderName,
			A.IndigoClientId, A.PolicyDetailId, A.PolicyNumber, A.FormattedPolicyNumber,
			A.PortalReference, 
			A.RefPlanType2ProdSubTypeId, A.ProviderPlanType,
			A.NINumber, A.DOB, A.LastName, 
			A.Postcode, A.PolicyStatusId, A.PolicyStartDate,
			A.PolicyOwnerCRMContactID, A.SellingAdviserCRMContactID, A.SellingAdviserStatus,
			A.ServicingAdviserCRMContactID, A.ServicingAdviserStatus
			,A.SequentialRef, A.IsExcluded,A.IsTopup
		) as 'BinaryCheckSum'
	Into #ExistingRecordCheckSum
	From #ExistingValPotentialPlan a

	select @ExistingNumberOfPolicies = @@ROWCOUNT

	Select b.PolicyBusinessId, 
		BINARY_CHECKSUM(
			B.ValuationProviderId, B.PolicyProviderId, B.PolicyProviderName,
			B.IndigoClientId, B.PolicyDetailId, B.PolicyNumber, b.FormattedPolicyNumber,
			B.PortalReference,   
			B.RefPlanType2ProdSubTypeId, B.ProviderPlanType,
			B.NINumber, B.DOB, B.LastName,
			B.Postcode, B.PlanStatusId, B.PolicyStartDate, 
			B.PolicyOwnerCRM, B.SellingCRM, B.SellingAdviserStatus,
			B.ServicingCRM, B.ServicingAdviserStatus
			,B.SequentialRef, B.IsExcluded,B.IsTopup
	) as 'BinaryCheckSum'
	Into #NewRecordCheckSum
	From #TValPotentialPlan b
			Join @PoliciesIdsToUse pbids on b.PolicyBusinessId = pbids.PolicyBusinessId

	select @NewNumberOfPolicies = @@ROWCOUNT

	create index idx_tmpExistingRecordCheckSum_pbid on #ExistingRecordCheckSum (PolicyBusinessId) include(BinaryCheckSum)
	create index idx_tmpNewRecordCheckSum_pbid on #NewRecordCheckSum (PolicyBusinessId) include(BinaryCheckSum)
	
	if @NewNumberOfPolicies = @ExistingNumberOfPolicies 
	begin
		if not exists (
					select 1 from 
						#NewRecordCheckSum n full outer join 
							#ExistingRecordCheckSum e on e.PolicyBusinessId = n.PolicyBusinessId
						where coalesce(e.BinaryCheckSum,0) <> coalesce(n.BinaryCheckSum,0))
			begin
				return
			end
	end

	UPDATE A
	Set A.ValuationProviderId = B.ValuationProviderId,A.PolicyProviderId = B.PolicyProviderId,A.PolicyProviderName = B.PolicyProviderName,A.IndigoClientId = B.IndigoClientId,
		A.PolicyDetailId = B.PolicyDetailId, A.PolicyNumber = B.PolicyNumber,A.PortalReference = B.PortalReference, 
		A.FormattedPortalReference = B.PortalReference, A.FormattedPolicyNumber = B.FormattedPolicyNumber,A.RefPlanType2ProdSubTypeId = B.RefPlanType2ProdSubTypeId,
		A.ProviderPlanType = B.ProviderPlanType,A.NINumber = B.NINumber,A.DOB = B.DOB,A.LastName = B.LastName,A.Postcode = B.Postcode,A.PolicyStatusId = B.PlanStatusId, 
		A.PolicyStartDate = B.PolicyStartDate, A.PolicyOwnerCRMContactID = B.PolicyOwnerCRM,A.SellingAdviserCRMContactID = B.SellingCRM,A.SellingAdviserStatus = B.SellingAdviserStatus,
		A.ServicingAdviserCRMContactID = B.ServicingCRM, A.ServicingAdviserStatus = B.ServicingAdviserStatus,
		A.IsExcluded = B.IsExcluded,A.IsTopup = B.IsTopup,A.SequentialRef  = B.SequentialRef,A.[EligibilityMask] = 0, A.EligibilityMaskRequiresUpdating = 1, A.ConcurrencyId = A.ConcurrencyId + 1
		OUTPUT 
			DELETED.ValuationProviderId, DELETED.PolicyProviderId, DELETED.PolicyProviderName, DELETED.IndigoClientId, DELETED.PolicyBusinessId,
			DELETED.PolicyDetailId, DELETED.PolicyNumber, DELETED.PortalReference , DELETED.FormattedPolicyNumber, DELETED.FormattedPortalReference
			,DELETED.RefPlanType2ProdSubTypeId, DELETED.ProviderPlanType,DELETED.NINumber, DELETED.DOB, DELETED.LastName, DELETED.Postcode
			,DELETED.PolicyStatusId,DELETED.PolicyStartDate,DELETED.PolicyOwnerCRMContactID,DELETED.SellingAdviserCRMContactID, DELETED.SellingAdviserStatus
			,DELETED.ServicingAdviserCRMContactID, DELETED.ServicingAdviserStatus
			,DELETED.EligibilityMask, DELETED.EligibilityMaskRequiresUpdating, DELETED.ConcurrencyId, DELETED.ValPotentialPlanId
			,DELETED.SequentialRef, deleted.IsTopup, deleted.IsExcluded
			, 'U', @ActionTime, @ActionUser
		INTO [TValPotentialPlanAudit]
		(ValuationProviderId, PolicyProviderId, PolicyProviderName,IndigoClientId, PolicyBusinessId, PolicyDetailId, PolicyNumber, PortalReference
			,FormattedPolicyNumber, FormattedPortalReference,RefPlanType2ProdSubTypeId, ProviderPlanType,NINumber,DOB,LastName,Postcode,PolicyStatusId, PolicyStartDate, PolicyOwnerCRMContactID
			,SellingAdviserCRMContactID, SellingAdviserStatus,ServicingAdviserCRMContactID,ServicingAdviserStatus,EligibilityMask
			,EligibilityMaskRequiresUpdating, ConcurrencyId, ValPotentialPlanId,SequentialRef, IsTopup, IsExcluded,StampAction,StampDateTime, StampUser)
	From TValPotentialPlan A
		Join #TValPotentialPlan B on a.PolicyBusinessId = b.PolicyBusinessId
		Join #ExistingRecordCheckSum existing on a.PolicyBusinessId = existing.PolicyBusinessId
		Join #NewRecordCheckSum new on b.PolicyBusinessId = new.PolicyBusinessId
	where existing.BinaryCheckSum <> new.BinaryCheckSum

	Insert Into TValPotentialPlan
	(ValuationProviderId,PolicyProviderId,PolicyProviderName, IndigoClientId,PolicyDetailId,PolicyNumber ,PortalReference, 
		FormattedPortalReference, FormattedPolicyNumber, RefPlanType2ProdSubTypeId, ProviderPlanType, NINumber, DOB, LastName, Postcode, PolicyStatusId, 
		PolicyStartDate, PolicyOwnerCRMContactID, SellingAdviserCRMContactID, SellingAdviserStatus, ServicingAdviserCRMContactID, ServicingAdviserStatus, 
		[EligibilityMask],EligibilityMaskRequiresUpdating,ConcurrencyId, PolicyBusinessId, SequentialRef, IsExcluded, IsTopup)
		OUTPUT 
			INSERTED.ValuationProviderId, INSERTED.PolicyProviderId, INSERTED.PolicyProviderName, INSERTED.IndigoClientId, 
			INSERTED.PolicyBusinessId,
			INSERTED.PolicyDetailId, INSERTED.PolicyNumber, INSERTED.PortalReference 
			,INSERTED.FormattedPolicyNumber, INSERTED.FormattedPortalReference
			,INSERTED.RefPlanType2ProdSubTypeId, INSERTED.ProviderPlanType
			,INSERTED.NINumber, INSERTED.DOB, INSERTED.LastName, INSERTED.Postcode
			,INSERTED.PolicyStatusId,INSERTED.PolicyStartDate,INSERTED.PolicyOwnerCRMContactID
			,INSERTED.SellingAdviserCRMContactID, INSERTED.SellingAdviserStatus
			,INSERTED.ServicingAdviserCRMContactID, INSERTED.ServicingAdviserStatus
			,INSERTED.EligibilityMask, INSERTED.EligibilityMaskRequiresUpdating, INSERTED.ConcurrencyId, INSERTED.ValPotentialPlanId
			,inserted.SequentialRef, inserted.IsTopup, inserted.IsExcluded
			, 'C', @ActionTime, @ActionUser
		INTO [TValPotentialPlanAudit]
		(ValuationProviderId, PolicyProviderId, PolicyProviderName
			,IndigoClientId, PolicyBusinessId, PolicyDetailId, PolicyNumber, PortalReference
			,FormattedPolicyNumber, FormattedPortalReference
			,RefPlanType2ProdSubTypeId, ProviderPlanType
			,NINumber,DOB,LastName,Postcode
			,PolicyStatusId, PolicyStartDate, PolicyOwnerCRMContactID
			,SellingAdviserCRMContactID, SellingAdviserStatus
			,ServicingAdviserCRMContactID,ServicingAdviserStatus
			,EligibilityMask, EligibilityMaskRequiresUpdating, ConcurrencyId, ValPotentialPlanId
			,SequentialRef, IsTopup, IsExcluded
			,StampAction
			, StampDateTime, StampUser) 
	Select A.ValuationProviderId, A.PolicyProviderId, A.PolicyProviderName, A.IndigoClientId, A.PolicyDetailId, A.PolicyNumber, A.PortalReference,  
		A.PortalReference, A.FormattedPolicyNumber, A.RefPlanType2ProdSubTypeId, A.ProviderPlanType, A.NINumber, A.DOB, A.LastName, A.Postcode, A.PlanStatusId, 
		A.PolicyStartDate, A.PolicyOwnerCRM, A.SellingCRM, A.SellingAdviserStatus, A.ServicingCRM, A.ServicingAdviserStatus, 
		0, 1, 1, A.PolicyBusinessId, A.SequentialRef, A.IsExcluded, A.IsTopup
	From #TValPotentialPlan A
		Left Join #ExistingValPotentialPlan B on a.PolicyBusinessId = b.PolicyBusinessId
	Where b.PolicyBusinessId is null

	Delete C
		OUTPUT 
			DELETED.ValuationProviderId, DELETED.PolicyProviderId, DELETED.PolicyProviderName, DELETED.IndigoClientId, 
			DELETED.PolicyBusinessId,DELETED.PolicyDetailId, DELETED.PolicyNumber, DELETED.PortalReference 
			,DELETED.FormattedPolicyNumber, DELETED.FormattedPortalReference,DELETED.RefPlanType2ProdSubTypeId, DELETED.ProviderPlanType
			,DELETED.NINumber, DELETED.DOB, DELETED.LastName, DELETED.Postcode,DELETED.PolicyStatusId,DELETED.PolicyStartDate,DELETED.PolicyOwnerCRMContactID
			,DELETED.SellingAdviserCRMContactID, DELETED.SellingAdviserStatus,DELETED.ServicingAdviserCRMContactID, DELETED.ServicingAdviserStatus
			,DELETED.EligibilityMask, DELETED.EligibilityMaskRequiresUpdating, DELETED.ConcurrencyId, DELETED.ValPotentialPlanId
			,DELETED.SequentialRef, deleted.IsTopup, deleted.IsExcluded, 'D', @ActionTime, @ActionUser
		INTO [TValPotentialPlanAudit]
		(ValuationProviderId, PolicyProviderId, PolicyProviderName,IndigoClientId, PolicyBusinessId, PolicyDetailId, PolicyNumber, PortalReference
			,FormattedPolicyNumber, FormattedPortalReference,RefPlanType2ProdSubTypeId, ProviderPlanType,NINumber,DOB,LastName,Postcode,PolicyStatusId, PolicyStartDate, PolicyOwnerCRMContactID
			,SellingAdviserCRMContactID, SellingAdviserStatus,ServicingAdviserCRMContactID,ServicingAdviserStatus,EligibilityMask
			,EligibilityMaskRequiresUpdating, ConcurrencyId, ValPotentialPlanId,SequentialRef, IsTopup, IsExcluded,StampAction, StampDateTime, StampUser)
	From @PoliciesIdsToUse A
	Left Join #TValPotentialPlan B On a.PolicyBusinessId = b.PolicyBusinessId
	Join TValPotentialPlan C on A.PolicyBusinessId = C.PolicyBusinessId
	Where b.PolicyBusinessId is null




SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET XACT_ABORT OFF
END
GO
