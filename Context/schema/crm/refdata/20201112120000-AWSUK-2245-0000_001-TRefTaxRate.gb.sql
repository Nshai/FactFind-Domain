 
-----------------------------------------------------------------------------
-- Table: CRM.TRefTaxRate
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '835A5E16-DC1A-4CAA-83E6-B324721D758E'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefTaxRate ON; 
 
        INSERT INTO TRefTaxRate([RefTaxRateId], [Name], [TaxRate], [IsArchived], [Extensible], [ConcurrencyId])
        SELECT 6, 'Additional rate',50,0,NULL,1 UNION ALL 
        SELECT 5, 'basic til april 2008',22,1,NULL,1 UNION ALL 
        SELECT 4, 'Low',10,0,NULL,1 UNION ALL 
        SELECT 3, 'higher',40,0,NULL,1 UNION ALL 
        SELECT 2, 'basic',20,0,NULL,1 UNION ALL 
        SELECT 1, 'non',0,0,NULL,1 UNION ALL 
        SELECT 7, 'Additional Rate from April 2013',45,0,NULL,1 UNION ALL 
        SELECT 8, 'Additional Rate from April 2018',19,0,NULL,1 UNION ALL 
        SELECT 9, 'Additional Rate from April 2018',21,0,NULL,1 UNION ALL 
        SELECT 10, 'Additional Rate from April 2018',41,0,NULL,1 UNION ALL 
        SELECT 11, 'Additional Rate from April 2018',46,0,NULL,1 
 
        SET IDENTITY_INSERT TRefTaxRate OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '835A5E16-DC1A-4CAA-83E6-B324721D758E', 
         'Initial load (11 total rows, file 1 of 1) for table TRefTaxRate',
         null, 
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
-- #Rows Exported: 11
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
