 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefPhiTransferCoverType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '723505B4-91F8-4585-8426-859764852AC4'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPhiTransferCoverType ON; 
 
        INSERT INTO TRefPhiTransferCoverType([RefPhiTransferCoverTypeId], [Name], [Description], [ConcurrencyId])
        SELECT 1, 'None', 'None',1 UNION ALL 
        SELECT 2, 'ASU', 'Accident, Sickness & Unemployment',1 UNION ALL 
        SELECT 3, 'AS', 'Accident & Sickness only ',1 UNION ALL 
        SELECT 4, 'UO', 'Unemployment Only',1 UNION ALL 
        SELECT 5, 'LASU', 'Life, Accident ,Sickness & Unemployment',1 UNION ALL 
        SELECT 6, 'ASUD', 'Accident ,Sickness, Unemployment & Death benefit',1 UNION ALL 
        SELECT 7, 'LAS', 'Life, Accident & Sickness',1 UNION ALL 
        SELECT 8, 'ASD', 'Accident, Sickness and Death benefit',1 UNION ALL 
        SELECT 9, 'LU', 'Life & Unemployment',1 UNION ALL 
        SELECT 10, 'UD', 'Unemployment & Death benefit',1 UNION ALL 
        SELECT 11, 'Other', '',1 
 
        SET IDENTITY_INSERT TRefPhiTransferCoverType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '723505B4-91F8-4585-8426-859764852AC4', 
         'Initial load (11 total rows, file 1 of 1) for table TRefPhiTransferCoverType',
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
