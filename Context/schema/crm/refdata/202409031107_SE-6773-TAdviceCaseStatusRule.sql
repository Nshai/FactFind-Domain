USE crm;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @AdviceCaseStatusRuleId1 INT = 1
      , @AdviceCaseStatusRuleId2 INT = 2
      , @AdviceCaseStatusRuleId3 INT = 3

/*
Summary
Rename "binder" to "folder" for Compliance-File Checking 
DatabaseName          TableName                    Expected Rows
crm                   TAdviceCaseStatusRule        3
*/

SELECT 
    @ScriptGUID = '4830B782-857D-4C4F-825F-DB9DE1B92FEA',
    @Comments = 'SE-6773- Rename Binders to Folders - Compliance-File Checking'


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRY

    BEGIN TRANSACTION

    UPDATE [dbo].[TAdviceCaseStatusRule]
    SET [RuleDescriptor] = REPLACE([RuleDescriptor], 'binder', 'folder'), 
        [ActionDescriptor]= REPLACE([ActionDescriptor], 'binder', 'folder')
    OUTPUT
        deleted.RuleDescriptor,
        deleted.ActionDescriptor,
        deleted.IsArchived,
        deleted.ConcurrencyId,
        deleted.AdviceCaseStatusRuleId,
         'U',
        GETUTCDATE(),
        0
       	INTO [dbo].[TAdviceCaseStatusRuleAudit](
        [RuleDescriptor],
        [ActionDescriptor],
        [IsArchived],
        [ConcurrencyId],
        [AdviceCaseStatusRuleId],
        [StampAction],
        [StampDateTime],
        [StampUser]
    )
    WHERE [AdviceCaseStatusRuleId] IN (@AdviceCaseStatusRuleId1,@AdviceCaseStatusRuleId2)

    UPDATE [dbo].[TAdviceCaseStatusRule]
    SET [RuleDescriptor] = REPLACE([RuleDescriptor], 'binder', 'folder'), 
        [ActionDescriptor]= REPLACE([ActionDescriptor], 'Binder', 'Folder')
    OUTPUT
        deleted.RuleDescriptor,
        deleted.ActionDescriptor,
        deleted.IsArchived,
        deleted.ConcurrencyId,
        deleted.AdviceCaseStatusRuleId,
         'U',
        GETUTCDATE(),
        0
       	INTO [dbo].[TAdviceCaseStatusRuleAudit](
        [RuleDescriptor],
        [ActionDescriptor],
        [IsArchived],
        [ConcurrencyId],
        [AdviceCaseStatusRuleId],
        [StampAction],
        [StampDateTime],
        [StampUser]
    )
    WHERE [AdviceCaseStatusRuleId] = @AdviceCaseStatusRuleId3

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