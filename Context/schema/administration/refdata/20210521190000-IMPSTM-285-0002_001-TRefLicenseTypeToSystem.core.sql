-----------------------------------------------------------------------------
-- Table: Administration.TRefLicenseTypeToSystem
--    Join: 
--   Where: 
-----------------------------------------------------------------------------


USE Administration

-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '14497568-6CFA-495D-B6B9-FFDC70CFC4FB'
) RETURN

-- Expected row counts: - if you know this
--(3 row(s) affected)

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION

        -- insert the records
        DECLARE @StampActionCreate CHAR(1) = 'C'
            , @StampActionUpdate CHAR(1) = 'U'
            , @StampDateTime DATETIME = GETUTCDATE()
            , @StampUser VARCHAR(255) = '0'

        INSERT INTO [dbo].[TRefLicenseTypeToSystem]([RefLicenseTypeId], [SystemId])
        OUTPUT inserted.[RefLicenseTypeToSystemId]
            , inserted.[RefLicenseTypeId]
            , inserted.[SystemId]
            , inserted.[ConcurrencyId]
            , @StampActionCreate
            , @StampDateTime
            , @StampUser
        INTO [dbo].[TRefLicenseTypeToSystemAudit]([RefLicenseTypeToSystemId], [RefLicenseTypeId], [SystemId], [ConcurrencyId], [StampAction], [StampDateTime], [StampUser])
        SELECT 1, SystemId
        FROM [dbo].[TSystem]
        WHERE SystemPath IN ('adviserworkplace.fundanalysis.modelportfolio.publishedmodels'
            , 'adviserworkplace.fundanalysis.modelportfolio.draftmodels'
            , 'adviserworkplace.fundanalysis.modelportfolio.draftimpsmodels')

        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp)
        VALUES (
         '14497568-6CFA-495D-B6B9-FFDC70CFC4FB',
         'IMPSTM-285 - Update Security Settings.',
         null,
         getdate())

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
