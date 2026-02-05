 
-----------------------------------------------------------------------------
-- Table: Administration.TIndClientCommissionDef
--    Join: 
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '53535D0F-40B3-4822-8904-3F390F8D8985'
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
        SET IDENTITY_INSERT TIndClientCommissionDef ON; 
 
        INSERT INTO TIndClientCommissionDef([IndClientCommissionDefId], [IndigoClientId], [AllowClawbackFG], [DateOrder], [PayCurrentGroupFG], [RecalcIntroducerSplitFG], [RecalcPractPercentFG], [DefaultPayeeEntityId], [PMMaxDiffAmount], [PMUseLinkProviderFG], [PMUseLookupFG], [PMMatchSurnameFirstFG], [PMMatchSurnameLastFG], [PMMatchCompanyNameFG], [CMUseLinkProviderFG], [CMProvDescLength], [CMDateRangeUpper], [CMDateRangeLower], [MinBACSAmount], [ConcurrencyId])
        SELECT 3367,12498,0, 'Desc',0,0,0,NULL,25.00,1,1,1,1,1,1,18,14,14,25.00,1 
 
        SET IDENTITY_INSERT TIndClientCommissionDef OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '53535D0F-40B3-4822-8904-3F390F8D8985', 
         'Initial load (1 total rows, file 1 of 1) for table TIndClientCommissionDef',
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
