USE PolicyManagement;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX);

SELECT @ScriptGUID = 'CDA6FC71-EDFB-4204-B21B-CAD7D2BF908D',
       @Comments = 'INTCA2-280 Update description in TRefPlanAction';

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @starttrancount INT;

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT;
    IF @starttrancount = 0

    BEGIN TRANSACTION;

    UPDATE [dbo].[TRefPlanAction]
      SET [Description] = 'Change Type',
          [LongDescription] = 'Ability to change the type from the actions menu.'
    WHERE [RefPlanActionId] = 1 AND [Description] = 'Change Plan Type';

    UPDATE [dbo].[TRefPlanAction]
      SET [LongDescription] = 'Ability to modify the expected commission within the Commissions tab.'
    WHERE [RefPlanActionId] = 2 AND [Description] = 'Modify Expected Commission';

    UPDATE [dbo].[TRefPlanAction]
      SET [LongDescription] = 'Ability to change the provider address within the Summary tab.'
    WHERE [RefPlanActionId] = 3 AND [Description] = 'Change Provider Address';

    UPDATE [dbo].[TRefPlanAction]
      SET [LongDescription] = 'Ability to change the provider from the actions menu.'
    WHERE [RefPlanActionId] = 4 AND [Description] = 'Change Provider';

    UPDATE [dbo].[TRefPlanAction]
      SET [LongDescription] = 'Ability to change agency number within the Summary tab.'
    WHERE [RefPlanActionId] = 5 AND [Description] = 'Change Agency Number';

    UPDATE [dbo].[TRefPlanAction]
      SET [LongDescription] = 'Ability to change the selling adviser from the actions menu.'
    WHERE [RefPlanActionId] = 6 AND [Description] = 'Change Selling Adviser';

    UPDATE [dbo].[TRefPlanAction]
      SET [LongDescription] = 'Ability to modify the Commission rate.'
    WHERE [RefPlanActionId] = 10 AND [Description] = 'Modify Commission Rate';

    UPDATE [dbo].[TRefPlanAction]
      SET [LongDescription] = 'Ability to edit the status change date held within the history tab.'
    WHERE [RefPlanActionId] = 11 AND [Description] = 'Edit Status Change Date';

    UPDATE [dbo].[TRefPlanAction]
      SET [LongDescription] = 'Ability to add a new top-up.'
    WHERE [RefPlanActionId] = 12 AND [Description] = 'Add Top-Up';

    UPDATE [dbo].[TRefPlanAction]
      SET [Description] = 'Change Owner',
          [LongDescription] = 'Ability to change owner 1 using the "Change Ownership" action from the actions menu.'
    WHERE [RefPlanActionId] = 19 AND [Description] = 'Change Plan Owner';

    UPDATE [dbo].[TRefPlanAction]
      SET [LongDescription] = 'Ability to request a fund switch, this is dependent on supported Wealthlink providers.'
    WHERE [RefPlanActionId] = 20 AND [Description] = 'Switch Request';

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