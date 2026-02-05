 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefAdviseFeeChargingType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '9745D1AF-8049-43E0-912D-1FEAAA9CE41E'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefAdviseFeeChargingType ON; 
 
        INSERT INTO TRefAdviseFeeChargingType([RefAdviseFeeChargingTypeId], [Name], [IsUsedAsInitialFee], [IsUsedAsRecurringFee], [IsUsedAsOneOffFee], [IsPercentageBased])
        SELECT 1, 'Fixed Price',1,1,1,0 UNION ALL 
        SELECT 2, '% of FUM/AUM',0,1,0,1 UNION ALL 
        SELECT 3, '% of All Investment Contribution',1,1,0,1 UNION ALL 
        SELECT 4, 'Non-chargeable',1,0,1,0 UNION ALL 
        SELECT 5, 'Fixed price-Range',1,1,1,0 UNION ALL 
        SELECT 6, 'Billing rate fee - Time Based',1,0,1,0 UNION ALL 
        SELECT 7, 'Billing rate fee - Task Based',1,0,1,0 UNION ALL 
        SELECT 8, '% of Regular Contribution',1,1,0,1 UNION ALL 
        SELECT 9, '% of Lump Sum Contribution',1,1,0,1 UNION ALL 
        SELECT 10, '% of Transfer Contribution',1,1,0,1 
 
        SET IDENTITY_INSERT TRefAdviseFeeChargingType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '9745D1AF-8049-43E0-912D-1FEAAA9CE41E', 
         'Initial load (10 total rows, file 1 of 1) for table TRefAdviseFeeChargingType',
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
-- #Rows Exported: 10
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
