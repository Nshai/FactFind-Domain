-----------------------------------------------------------------------------
-- Table: Administration.TSystem
--    Join:
--   Where:
-----------------------------------------------------------------------------


USE Administration

-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript
   WHERE ScriptGuid = '78C7042F-DBE9-4D66-AEE5-46EEEFD8926C'
) RETURN

-- Expected row counts: - if you know this
--(3 row(s) affected)
--(1 row(s) affected)

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount INT
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION

        DECLARE @StampActionCreate CHAR(1) = 'C'
            , @StampActionUpdate CHAR(1) = 'U'
            , @StampDateTime DATETIME = GETUTCDATE()
            , @StampUser VARCHAR(255) = '0'
            , @ParentId INT
            , @PortfolioActionsSystemId INT

        SELECT @ParentId = [SystemId]
        FROM [dbo].[TSystem]
        WHERE SystemPath = 'adviserworkplace.fundanalysis.modelportfolio'

        INSERT INTO [dbo].[TSystem]([Identifier], [Description], [SystemPath], [SystemType], [ParentId])
        OUTPUT inserted.[SystemId]
            , inserted.[Identifier]
            , inserted.[Description]
            , inserted.[SystemPath]
            , inserted.[SystemType]
            , inserted.[ParentId]
            , inserted.[ConcurrencyId]
            , @StampActionCreate
            , @StampDateTime
            , @StampUser
        INTO [dbo].[TSystemAudit]([SystemId], [Identifier], [Description], [SystemPath], [SystemType], [ParentId], [ConcurrencyId], [StampAction], [StampDateTime], [StampUser])
        VALUES
            ('draftimpsmodels'
            ,'Draft iMPS Models'
            ,'adviserworkplace.fundanalysis.modelportfolio.draftimpsmodels'
            ,'-system'
            ,@ParentId),
            ('draftmodels'
            ,'Draft Models'
            ,'adviserworkplace.fundanalysis.modelportfolio.draftmodels'
            ,'-system'
            ,@ParentId),
            ('publishedmodels'
            ,'Published Models'
            ,'adviserworkplace.fundanalysis.modelportfolio.publishedmodels'
            ,'-system'
            ,@ParentId)

        SELECT @PortfolioActionsSystemId = SystemId
        FROM [dbo].[TSystem]
        WHERE SystemPath = 'portfolio.actions'

        UPDATE [administration].[dbo].[TSystem]
        SET Description = 'Create/Update/Delete Portfolio'
            , ParentId = @PortfolioActionsSystemId
        OUTPUT deleted.[SystemId]
            , deleted.[Identifier]
            , deleted.[Description]
            , deleted.[SystemPath]
            , deleted.[SystemType]
            , deleted.[ParentId]
            , deleted.[ConcurrencyId]
            , @StampActionUpdate
            , @StampDateTime
            , @StampUser
        INTO [dbo].[TSystemAudit]([SystemId], [Identifier], [Description], [SystemPath], [SystemType], [ParentId], [ConcurrencyId], [StampAction], [StampDateTime], [StampUser])
        WHERE SystemPath = 'adviserworkplace.fundanalysis.actions.addportfolio'

        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp)
        VALUES (
         '78C7042F-DBE9-4D66-AEE5-46EEEFD8926C',
         'IMPSTM-285 - Update Security Settings.',
         null,
         @StampDateTime)

   IF @starttrancount = 0
    COMMIT TRANSACTION

END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH

 SET XACT_ABORT OFF
 SET NOCOUNT OFF
