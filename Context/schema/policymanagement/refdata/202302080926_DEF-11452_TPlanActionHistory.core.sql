USE PolicyManagement;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @ErrorMessage VARCHAR(MAX)
        , @StampActionUpdate CHAR(1) = 'U'
        , @StampActionCreate CHAR(1) = 'C'
        , @StampDateTime DATETIME = getdate()
        , @StampUserSystem CHAR(1) = '0'  
        , @CurrentProviderName VARCHAR(255) = 'Cazenove'
        , @NewProviderName VARCHAR(255) = 'Cazenove Capital'
        , @RefPlanActionIdModifyProvider INT = 4
        , @CurrentProviderId BIGINT 
        , @NewProviderId BIGINT

/*
Summary
Change all plans from cazenove to cazenove capital, archive cazenove

DatabaseName        TableName      Expected Rows
PolicyManagement    TPlanActionHistory  3103
PolicyManagement    TPlanDescription    3103
commissions         TDnPolicyMatching   3316
PolicyManagement    TRefProdProvider    1
PolicyManagement    TValPotentialPlan   2984
sdb                 RecommendationProposal  13
*/


SELECT 
    @ScriptGUID = '8E1E7B6C-F6D6-4B1F-9D80-9F39EDA73EC4', 
    @Comments = 'DEF-11452 Change all plans from cazenove to cazenove capital'


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

SELECT @CurrentProviderId = RefProdProviderId FROM VProvider WHERE [Name] = @CurrentProviderName
SELECT @NewProviderId = RefProdProviderId FROM VProvider WHERE [Name] = @NewProviderName

BEGIN TRY

    BEGIN TRANSACTION

    INSERT 
        TPlanActionHistory
        (PolicyBusinessId, RefPlanActionId, ChangedFrom, ChangedTo, DateOfChange, ChangedByUserId)
    OUTPUT 
        inserted.PlanActionHistoryId, inserted.PolicyBusinessId, inserted.RefPlanActionId, inserted.ChangedFrom, inserted.ChangedTo, inserted.DateOfChange, 
        inserted.ChangedByUserId,inserted.ConcurrencyId, @StampActionCreate, @StampDateTime, @StampUserSystem
    INTO 
        TPlanActionHistoryAudit
        (PlanActionHistoryId, PolicyBusinessId, RefPlanActionId, ChangedFrom, ChangedTo, DateOfChange, ChangedByUserId, ConcurrencyId, StampAction, StampDateTime, StampUser)
    SELECT 
        PB.PolicyBusinessId, @RefPlanActionIdModifyProvider, @CurrentProviderName, @NewProviderName, @StampDateTime, @StampUserSystem
    FROM 
        TPolicyBusiness PB
        JOIN TPolicyDetail PD ON PD.PolicyDetailId = PB.PolicyDetailId
        JOIN TPlanDescription PDes ON PDes.PlanDescriptionId = PD.PlanDescriptionId
        join PolicyManagement.dbo.[VStatusHistory] STH on PB.PolicyBusinessId = STH.PolicyBusinessId and STH.CurrentStatusFG = 1
        join PolicyManagement.dbo.[TStatus] STAT on STH.StatusId = STAT.StatusId
    WHERE
        PDes.RefProdProviderId = @CurrentProviderId
        AND STAT.Name <> 'Out of Force'
        AND STAT.Name <> 'Deleted'

    UPDATE U
    SET
        U.RefProdProviderId = @NewProviderId,
        U.ConcurrencyId = U.ConcurrencyId + 1
    OUTPUT 
        deleted.RefPlanType2ProdSubTypeId, deleted.RefProdProviderId, deleted.SchemeOwnerCRMContactId, deleted.SchemeStatus, deleted.SchemeNumber, deleted.SchemeName, 
        deleted.SchemeStatusDate, deleted.MaturityDate, deleted.ConcurrencyId, deleted.PlanDescriptionId, @StampActionUpdate, @StampDateTime, @StampUserSystem, deleted.PlanMigrationRef
    INTO 
        TPlanDescriptionAudit
        (RefPlanType2ProdSubTypeId, RefProdProviderId, SchemeOwnerCRMContactId, SchemeStatus, SchemeNumber, SchemeName, SchemeStatusDate, MaturityDate, 
            ConcurrencyId, PlanDescriptionId, StampAction, StampDateTime, StampUser, PlanMigrationRef)
    FROM
        TPlanDescription U
        JOIN TPolicyDetail PD ON PD.PlanDescriptionId = U.PlanDescriptionId
        JOIN TPolicyBusiness PB ON PB.PolicyDetailId = PD.PolicyDetailId
        join PolicyManagement.dbo.[VStatusHistory] STH on PB.PolicyBusinessId = STH.PolicyBusinessId and STH.CurrentStatusFG = 1
        join PolicyManagement.dbo.[TStatus] STAT on STH.StatusId = STAT.StatusId
    WHERE
        U.RefProdProviderId = @CurrentProviderId			
        AND STAT.Name <> 'Out of Force'
        AND STAT.Name <> 'Deleted'


    UPDATE dn
    SET
        dn.RefProdProviderId = @NewProviderId,
        dn.ProviderName = @NewProviderName,
        dn.ConcurrencyId = dn.ConcurrencyId + 1
    OUTPUT
        deleted.BandingTemplateId, deleted.ClientFirstName, deleted.ClientId, deleted.ClientLastName, deleted.ConcurrencyId, deleted.DnPolicyMatchingId, deleted.ExpCommAmount, 
        deleted.GroupId, deleted.IndClientId, deleted.PolicyId, deleted.PolicyNo, deleted.PolicyRef, deleted.PractitionerId, deleted.PractName, 
        deleted.PractUserId, deleted.PreSubmissionFG, deleted.ProviderName, deleted.RefComTypeId, deleted.RefComTypeName, deleted.RefPlanType2ProdSubTypeId, deleted.RefProdProviderId, 
        deleted.StatusDate, deleted.StatusId, deleted.SubmittedDate, deleted.TopupMasterPolicyId, @StampActionUpdate, @StampDateTime, @StampUserSystem
    INTO
        commissions..TDnPolicyMatchingAudit
        (BandingTemplateId, ClientFirstName, ClientId, ClientLastName, ConcurrencyId, DnPolicyMatchingId, ExpCommAmount,
        GroupId, IndClientId, PolicyId, PolicyNo, PolicyRef, PractitionerId, PractName,
        PractUserId, PreSubmissionFG, ProviderName, RefComTypeId, RefComTypeName, RefPlanType2ProdSubTypeId, RefProdProviderId,
        StatusDate, StatusId, SubmittedDate, TopupMasterPolicyId, StampAction, StampDateTime, StampUser)
    FROM
        commissions..TDnPolicyMatching dn 		   
        JOIN TPolicyBusiness PB on PB.PolicyBusinessId = dn.PolicyId
        JOIN TPolicyDetail PD ON PB.PolicyDetailId = PD.PolicyDetailId
        JOIN TPlanDescription U ON PD.PlanDescriptionId = U.PlanDescriptionId
        join PolicyManagement.dbo.[VStatusHistory] STH on PB.PolicyBusinessId = STH.PolicyBusinessId and STH.CurrentStatusFG = 1
        join PolicyManagement.dbo.[TStatus] STAT on STH.StatusId = STAT.StatusId
    WHERE
        dn.RefProdProviderId = @CurrentProviderId			
        AND STAT.Name <> 'Out of Force'
        AND STAT.Name <> 'Deleted'

    EXEC SpNAuditRefProdProvider @StampUserSystem, @CurrentProviderId, @StampActionUpdate

    UPDATE TRefProdProvider
    SET RetireFg = 1
    WHERE RefProdProviderId = @CurrentProviderId

    UPDATE TValPotentialPlan
    SET PolicyProviderName = @NewProviderName
    OUTPUT
        deleted.AgencyNumber,
        deleted.ConcurrencyId,
        deleted.DOB,
        deleted.EligibilityMask,
        deleted.EligibilityMaskRequiresUpdating,
        deleted.ExtendValuationsByServicingAdviser,
        deleted.FormattedPolicyNumber,
        deleted.FormattedPortalReference,
        deleted.IndigoClientId,
        deleted.IsExcluded,
        deleted.IsTopup,
        deleted.LastName,
        deleted.NINumber,
        deleted.PolicyBusinessId,
        deleted.PolicyDetailId,
        deleted.PolicyNumber,
        deleted.PolicyOwnerCRMContactID,
        deleted.PolicyProviderId,
        deleted.PolicyProviderName,
        deleted.PolicyStartDate,
        deleted.PolicyStatusId,
        deleted.PortalReference,
        deleted.Postcode,
        deleted.ProviderPlanType,
        deleted.RefPlanType2ProdSubTypeId,
        deleted.SellingAdviserCRMContactID,
        deleted.SellingAdviserStatus,
        deleted.SequentialRef,
        deleted.ServicingAdviserCRMContactID,
        deleted.ServicingAdviserStatus,
        @StampActionUpdate,
        GETUTCDATE(),
        @StampUserSystem,
        deleted.ValPotentialPlanId,
        deleted.ValuationProviderId
    INTO TValPotentialPlanAudit(
        AgencyNumber,
        ConcurrencyId,
        DOB,
        EligibilityMask,
        EligibilityMaskRequiresUpdating,
        ExtendValuationsByServicingAdviser,
        FormattedPolicyNumber,
        FormattedPortalReference,
        IndigoClientId,
        IsExcluded,
        IsTopup,
        LastName,
        NINumber,
        PolicyBusinessId,
        PolicyDetailId,
        PolicyNumber,
        PolicyOwnerCRMContactID,
        PolicyProviderId,
        PolicyProviderName,
        PolicyStartDate,
        PolicyStatusId,
        PortalReference,
        Postcode,
        ProviderPlanType,
        RefPlanType2ProdSubTypeId,
        SellingAdviserCRMContactID,
        SellingAdviserStatus,
        SequentialRef,
        ServicingAdviserCRMContactID,
        ServicingAdviserStatus,
        StampAction,
        StampDateTime,
        StampUser,
        ValPotentialPlanId,
        ValuationProviderId
    )
    WHERE PolicyProviderName = @CurrentProviderName

    UPDATE sdb..RecommendationProposal
    SET NewBusinessPlanProviderName = @NewProviderName, NewBusinessPlanProviderId = @NewProviderId
    WHERE NewBusinessPlanProviderId = @CurrentProviderId

    UPDATE sdb..RecommendationProposal
    SET PlanProductProviderName = @NewProviderName, PlanProductProviderId = @NewProviderId
    WHERE PlanProductProviderId = @CurrentProviderId

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    COMMIT TRANSACTION

END TRY
BEGIN CATCH
    
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;