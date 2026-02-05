USE PolicyManagement;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @StampActionUpdate CHAR(1) = 'U'
        , @StampActionCreate CHAR(1) = 'C'
        , @StampDateTime DATETIME = GETUTCDATE()
        , @StampUserSystem CHAR(1) = '0'       
        , @RefPlanActionIdModifyProvider INT = 4
        , @LGTVestraLLP varchar(255) = 'LGT Vestra LLP'
        , @LGTVestraUSLtd varchar(255) = 'LGT Vestra US Ltd'
        , @LGTVestraJerseyLimited varchar(255) = 'LGT Vestra (Jersey) Limited'
        , @LGTWealthManagementUKLLP varchar(255) = 'LGT Wealth Management UK LLP'
        , @LGTWealthManagementUSLimited varchar(255) = 'LGT Wealth Management US Limited'
        , @LGTWealthManagementJerseyLimited varchar(255) = 'LGT Wealth Management Jersey Limited'

/*Summary
Archive 2 providers
Move all active plans with 3 providers to 3 different providers

DatabaseName        TableName      Expected Rows
PolicyManagement    TRefProdProvider    2
PolicyManagement    TPlanActionHistory  5965
PolicyManagement    TPlanDescription    5965
commissions         TDnPolicyMatching   6314
*/

SELECT 
    @ScriptGUID = '7F44FCDB-4045-4594-BDAE-774DB2EB2642', 
    @Comments = 'DEF-9868 LGT Provider archive and plan move'


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

    CREATE TABLE #Mapping (
        CurrentProviderName varchar(255)
        , CurrentProviderId int
        , NewProviderName varchar(255)
        , NewProviderId int
    )

    INSERT INTO #Mapping (CurrentProviderName, NewProviderName)
    VALUES 
        (@LGTVestraJerseyLimited, @LGTWealthManagementJerseyLimited)
        , (@LGTVestraLLP, @LGTWealthManagementUKLLP)
        , (@LGTVestraUSLtd, @LGTWealthManagementUSLimited)
        , (@LGTWealthManagementJerseyLimited, null)
        , (@LGTWealthManagementUKLLP, null)
        , (@LGTWealthManagementUSLimited, null)

    UPDATE m
    SET m.CurrentProviderId = p1.RefProdProviderId, m.NewProviderId = p2.RefProdProviderId
    FROM #Mapping m
    JOIN CRM..TCRMContact c1 ON m.CurrentProviderName = c1.CorporateName
    JOIN TRefProdProvider p1 ON c1.CRMContactId = p1.CRMContactId
    LEFT JOIN CRM..TCRMContact c2 ON m.NewProviderName = c2.CorporateName
    LEFT JOIN TRefProdProvider p2 ON c2.CRMContactId = p2.CRMContactId

BEGIN TRY

    BEGIN TRANSACTION

    UPDATE p 
    SET ConcurrencyId += 1, RetireFg = 1
    OUTPUT
        deleted.ConcurrencyId,
        deleted.CRMContactId,
        deleted.DTCCIdentifier,
        deleted.FundProviderId,
        deleted.IsBankAccountTransactionFeed,
        deleted.IsConsumerFriendly,
        deleted.IsTransactionFeedSupported,
        deleted.NewProdProviderId,
        deleted.RefProdProviderId,
        deleted.RegionCode,
        deleted.RetireFg,
        @StampActionUpdate,
        @StampDateTime,
        @StampUserSystem
    INTO TRefProdProviderAudit(
        ConcurrencyId,
        CRMContactId,
        DTCCIdentifier,
        FundProviderId,
        IsBankAccountTransactionFeed,
        IsConsumerFriendly,
        IsTransactionFeedSupported,
        NewProdProviderId,
        RefProdProviderId,
        RegionCode,
        RetireFg,
        StampAction,
        StampDateTime,
        StampUser
    )
    FROM TRefProdProvider p
    JOIN #Mapping m ON p.RefProdProviderId = m.CurrentProviderId
    WHERE m.CurrentProviderName IN (@LGTVestraJerseyLimited, @LGTVestraUSLtd)

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
        PB.PolicyBusinessId, @RefPlanActionIdModifyProvider, m.CurrentProviderName, m.NewProviderName, @StampDateTime, @StampUserSystem
    FROM 
        TPolicyBusiness PB
        JOIN TPolicyDetail PD ON PD.PolicyDetailId = PB.PolicyDetailId
        JOIN TPlanDescription PDes ON PDes.PlanDescriptionId = PD.PlanDescriptionId
        JOIN [VStatusHistory] STH ON PB.PolicyBusinessId = STH.PolicyBusinessId and STH.CurrentStatusFG = 1
        JOIN [TStatus] STAT ON STH.StatusId = STAT.StatusId
        JOIN #Mapping m ON PDes.RefProdProviderId = m.CurrentProviderId
    WHERE
        STAT.[Name] <> 'Out of Force'
        AND STAT.[Name] <> 'Deleted'
        AND m.NewProviderId IS NOT NULL

    UPDATE U
    SET
        U.RefProdProviderId = m.NewProviderId,
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
        JOIN [VStatusHistory] STH on PB.PolicyBusinessId = STH.PolicyBusinessId and STH.CurrentStatusFG = 1
        JOIN [TStatus] STAT on STH.StatusId = STAT.StatusId
        JOIN #Mapping m ON u.RefProdProviderId = m.CurrentProviderId
    WHERE
        STAT.[Name] <> 'Out of Force'
        AND STAT.[Name] <> 'Deleted'
        AND m.NewProviderId IS NOT NULL

    UPDATE dn
    SET
        dn.RefProdProviderId = m.NewProviderId,
        dn.ProviderName = m.NewProviderName,
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
        JOIN [VStatusHistory] STH on PB.PolicyBusinessId = STH.PolicyBusinessId and STH.CurrentStatusFG = 1
        JOIN [TStatus] STAT on STH.StatusId = STAT.StatusId
        JOIN #Mapping m ON U.RefProdProviderId = m.CurrentProviderId
    WHERE		
        STAT.[Name] <> 'Out of Force'
        AND STAT.[Name] <> 'Deleted'
        AND m.NewProviderId IS NOT NULL

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    COMMIT TRANSACTION

END TRY
BEGIN CATCH
    
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

END CATCH

DROP TABLE IF EXISTS #Mapping;

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;