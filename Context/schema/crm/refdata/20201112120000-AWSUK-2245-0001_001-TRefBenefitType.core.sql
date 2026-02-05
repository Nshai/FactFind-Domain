 
-----------------------------------------------------------------------------
-- Table: CRM.TRefBenefitType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '58CC08CA-F806-4017-83FE-5A430B4C8151'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefBenefitType ON; 
 
        INSERT INTO TRefBenefitType([RefBenefitTypeId], [Name], [Extensible], [ConcurrencyId])
        SELECT 7, 'Pension Contributions',NULL,1 UNION ALL 
        SELECT 6, 'Staff Discounts',NULL,1 UNION ALL 
        SELECT 5, 'Travel',NULL,1 UNION ALL 
        SELECT 4, 'Mortgage Subsidy',NULL,1 UNION ALL 
        SELECT 3, 'Healthcare',NULL,1 UNION ALL 
        SELECT 2, 'Petrol',NULL,1 UNION ALL 
        SELECT 1, 'Car',NULL,1 
 
        SET IDENTITY_INSERT TRefBenefitType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '58CC08CA-F806-4017-83FE-5A430B4C8151', 
         'Initial load (7 total rows, file 1 of 1) for table TRefBenefitType',
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
-- #Rows Exported: 7
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
