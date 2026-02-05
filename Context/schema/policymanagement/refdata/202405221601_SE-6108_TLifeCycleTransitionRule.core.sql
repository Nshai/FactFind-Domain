USE policymanagement;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @LifeCycleTransitionRuleId1 INT = 32
      , @LifeCycleTransitionRuleId2 INT = 34

/*
Summary
Rename "binder" to "folder" for lifecycle transition rules 
DatabaseName          TableName                    Expected Rows
policymanagement      TLifeCycleTransitionRule     2
*/

SELECT 
    @ScriptGUID = 'FAD85EE9-5D6A-4819-B39A-8FCF448ACEDA',
    @Comments = 'SE-6108 - Rename "binder" to "folder" for lifecycle transition rules'


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRY

    BEGIN TRANSACTION

    UPDATE [dbo].[TLifeCycleTransitionRule]
    SET [Name] = REPLACE([Name], 'binder', 'folder'), 
        [Description] = REPLACE([Description], 'binder', 'folder')
    OUTPUT
        deleted.TenantId,
        deleted.Name,
        deleted.Code,
        deleted.Description,
        deleted.SpName,
        deleted.ConcurrencyId,
        deleted.LifeCycleTransitionRuleId,
        'U',
        GETUTCDATE(),
        0,
        deleted.RefLifecycleRuleCategoryId
    INTO [dbo].[TLifeCycleTransitionRuleAudit](
        [TenantId],
        [Name],
        [Code],
        [Description],
        [SpName],
        [ConcurrencyId],
        [LifeCycleTransitionRuleId],
        [StampAction],
        [StampDateTime],
        [StampUser],
        [RefLifecycleRuleCategoryId]
    )
    WHERE [LifeCycleTransitionRuleId] IN (@LifeCycleTransitionRuleId1, @LifeCycleTransitionRuleId2)

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