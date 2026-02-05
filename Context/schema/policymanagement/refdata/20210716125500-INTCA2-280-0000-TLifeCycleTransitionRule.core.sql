USE PolicyManagement;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX);

SELECT @ScriptGUID = '591763E8-9B80-4D12-B455-089CA4216E07',
       @Comments = 'INTCA2-280 Update name in TLifeCycleTransitionRule';

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @starttrancount INT;

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT;
    IF @starttrancount = 0

    BEGIN TRANSACTION;

    UPDATE [dbo].[TLifeCycleTransitionRule]
      SET [Name] = 'Check for Purpose'
    WHERE [LifeCycleTransitionRuleId] = 7 AND [Name] = 'Check for Plan Purpose';

    UPDATE [dbo].[TLifeCycleTransitionRule]
      SET [Name] = 'Check for Open Service Case'
    WHERE [LifeCycleTransitionRuleId] = 25 AND [Name] = 'Check for Open Plan Service Case';

    UPDATE [dbo].[TLifeCycleTransitionRule]
      SET [Name] = 'Check that mortgage "Income Evidenced?" checkbox is ticked'
    WHERE [LifeCycleTransitionRuleId] = 38 AND [Name] = 'Check that mortgage plan "Income Evidenced?" checkbox is ticked';

    UPDATE [dbo].[TLifeCycleTransitionRule]
      SET [Name] = 'Check for Linked Solicitor/Lenders Solicitor Used'
    WHERE [LifeCycleTransitionRuleId] = 39 AND [Name] = 'Check for plan Linked Solicitor/Lenders Solicitor Used';

    UPDATE [dbo].[TLifeCycleTransitionRule]
      SET [Name] = 'Check for Proposition'
    WHERE [LifeCycleTransitionRuleId] = 41 AND [Name] = 'Check for Plan Proposition';

    UPDATE [dbo].[TLifeCycleTransitionRule]
      SET [Name] = 'Check for Scheduled Valuation'
    WHERE [LifeCycleTransitionRuleId] = 51 AND [Name] = 'Check for Plan Scheduled Valuation';

    UPDATE [dbo].[TLifeCycleTransitionRule]
      SET [Name] = 'Check for Agency Status'
    WHERE [LifeCycleTransitionRuleId] = 211 AND [Name] = 'Check for Plan Agency Status';

    -- record execution so the script won't run again
    INSERT INTO TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments);

    IF @starttrancount = 0
        COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;
    DECLARE @ErrorLine INT;
    DECLARE @ErrorNumber INT;
    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE(),
           @ErrorNumber = ERROR_NUMBER(),
           @ErrorLine = ERROR_LINE();

    /*Insert into logging table - IF ANY	*/

    IF XACT_STATE() <> 0
       AND @starttrancount = 0
        ROLLBACK TRANSACTION;
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine);
END CATCH;

SET XACT_ABORT OFF;
SET NOCOUNT OFF;

RETURN;