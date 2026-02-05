 
-----------------------------------------------------------------------------
-- Table: FactFind.TRefInvestmentType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '46E0D525-5E7F-4888-868E-B5A0E9A4AC73'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefInvestmentType ON; 
 
        INSERT INTO TRefInvestmentType([RefInvestmentTypeId], [InvestmentType], [ConcurrencyId])
        SELECT 2, 'New Investment/Pension',0 UNION ALL 
        SELECT 1, 'Current Investments/Pensions',0 UNION ALL 
        SELECT 3, 'New & Current Investment/Pension',0 
 
        SET IDENTITY_INSERT TRefInvestmentType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '46E0D525-5E7F-4888-868E-B5A0E9A4AC73', 
         'Initial load (3 total rows, file 1 of 1) for table TRefInvestmentType',
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
-- #Rows Exported: 3
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
