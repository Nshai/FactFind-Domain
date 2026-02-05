 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefInsuranceClaimType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '0C34F743-A566-4B11-AD57-6B3C4C68B132'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefInsuranceClaimType ON; 
 
        INSERT INTO TRefInsuranceClaimType([RefInsuranceClaimTypeId], [Name], [ConcurrencyId])
        SELECT 1, 'Accidental Damage',1 UNION ALL 
        SELECT 2, 'Accidental Loss of Oil Or Water',1 UNION ALL 
        SELECT 3, 'Attempted Theft',1 UNION ALL 
        SELECT 4, 'Blocked Pipes',1 UNION ALL 
        SELECT 5, 'Contents in Open Within Grounds',1 UNION ALL 
        SELECT 6, 'Damage to Garden',1 UNION ALL 
        SELECT 7, 'Earthquake',1 UNION ALL 
        SELECT 8, 'Escape of Water',1 UNION ALL 
        SELECT 9, 'Explosion',1 UNION ALL 
        SELECT 10, 'Fire',1 UNION ALL 
        SELECT 11, 'Flood at a Previous Property',1 UNION ALL 
        SELECT 12, 'Flood at this Property',1 UNION ALL 
        SELECT 13, 'Freezer Contents',1 UNION ALL 
        SELECT 14, 'Liability',1 UNION ALL 
        SELECT 15, 'Lightning',1 UNION ALL 
        SELECT 16, 'Lock Replacement',1 UNION ALL 
        SELECT 17, 'Malicious Damage',1 UNION ALL 
        SELECT 18, 'Other',1 UNION ALL 
        SELECT 19, 'Pedal Cycles',1 UNION ALL 
        SELECT 20, 'Personal Possessions',1 UNION ALL 
        SELECT 21, 'Professional Remover Damage',1 UNION ALL 
        SELECT 22, 'Smoke',1 UNION ALL 
        SELECT 23, 'Storm Damage',1 UNION ALL 
        SELECT 24, 'Subsidence at a Previous Property',1 UNION ALL 
        SELECT 25, 'Subsidence at this Property',1 UNION ALL 
        SELECT 26, 'Theft',1 
 
        SET IDENTITY_INSERT TRefInsuranceClaimType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '0C34F743-A566-4B11-AD57-6B3C4C68B132', 
         'Initial load (26 total rows, file 1 of 1) for table TRefInsuranceClaimType',
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
-- #Rows Exported: 26
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
