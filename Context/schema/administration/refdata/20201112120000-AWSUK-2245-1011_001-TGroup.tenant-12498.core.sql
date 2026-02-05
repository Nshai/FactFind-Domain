 
-----------------------------------------------------------------------------
-- Table: Administration.TGroup
--    Join: 
--   Where: WHERE IndigoClientId = 12498
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '9628C5E2-4BFB-41A5-84BB-389304F4A67C'
     AND TenantId = 12498
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TGroup ON; 
 
        INSERT INTO TGroup([GroupId], [Identifier], [GroupingId], [ParentId], [CRMContactId], [IndigoClientId], [LegalEntity], [GroupImageLocation], [AcknowledgementsLocation], [FinancialYearEnd], [ApplyFactFindBranding], [VatRegNbr], [FSARegNbr], [AuthorisationText], [ConcurrencyId], [IsFSAPassport], [FRNNumber], [DocumentFileReference], [MigrationRef], [AdminEmail])
        SELECT 13187, 'Organisation',4955,NULL,20210840,12498,1, NULL, NULL,NULL,1, NULL, NULL, NULL,1,NULL, NULL, NULL, NULL, NULL 
 
        SET IDENTITY_INSERT TGroup OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '9628C5E2-4BFB-41A5-84BB-389304F4A67C', 
         'Initial load (1 total rows, file 1 of 1) for table TGroup',
         12498, 
         getdate() )
 
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
-----------------------------------------------------------------------------
-- #Rows Exported: 1
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
