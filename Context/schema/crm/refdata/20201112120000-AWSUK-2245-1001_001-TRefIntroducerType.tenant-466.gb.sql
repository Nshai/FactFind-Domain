 
-----------------------------------------------------------------------------
-- Table: CRM.TRefIntroducerType
--    Join: 
--   Where: WHERE IndClientId=466
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'C5358AE4-1305-44AE-980F-888D800FEECD'
     AND TenantId = 466
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefIntroducerType ON; 
 
        INSERT INTO TRefIntroducerType([RefIntroducerTypeId], [IndClientId], [ShortName], [LongName], [MinSplitRange], [MaxSplitRange], [DefaultSplit], [RenewalsFG], [ArchiveFG], [Extensible], [ConcurrencyId])
        SELECT 657,466, 'IUN', 'UnApproved',0.00,100.00,NULL,1,0, NULL,1 
 
        SET IDENTITY_INSERT TRefIntroducerType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'C5358AE4-1305-44AE-980F-888D800FEECD', 
         'Initial load (1 total rows, file 1 of 1) for table TRefIntroducerType',
         466, 
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
