 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TSchemeType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '7D1CC806-FA85-4B9B-ACE9-D251314DC9B4'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TSchemeType ON; 
 
        INSERT INTO TSchemeType([SchemeTypeId], [SchemeTypeName], [IsRetired], [ConcurrencyId], [RefLicenceTypeId])
        SELECT 1, 'Group Pension',0,1,1 UNION ALL 
        SELECT 2, 'Group Life',0,1,1 UNION ALL 
        SELECT 3, 'Group Income Protection',0,1,1 UNION ALL 
        SELECT 4, 'Group PMI',0,1,1 UNION ALL 
        SELECT 5, 'Other',0,1,1 UNION ALL 
        SELECT 6, 'Group Life',0,1,2 UNION ALL 
        SELECT 7, 'Group Income Protection',0,1,2 UNION ALL 
        SELECT 8, 'Group PMI',0,1,2 UNION ALL 
        SELECT 9, 'Other',0,1,2 UNION ALL 
        SELECT 10, 'Group Critical Illness',0,1,1 UNION ALL 
        SELECT 11, 'Group Critical Illness',0,1,2 
 
        SET IDENTITY_INSERT TSchemeType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '7D1CC806-FA85-4B9B-ACE9-D251314DC9B4', 
         'Initial load (11 total rows, file 1 of 1) for table TSchemeType',
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
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
