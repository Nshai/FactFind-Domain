 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefProductGroup
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '79BC0AB4-9C99-47EE-9FCF-95058642F912'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefProductGroup ON; 
 
        INSERT INTO TRefProductGroup([RefProductGroupId], [ProductGroupName], [IsArchived], [ConcurrencyId])
        SELECT 1, 'Term Protection',0,1 UNION ALL 
        SELECT 2, 'Income Protection',0,1 UNION ALL 
        SELECT 3, 'Whole of Life',0,1 UNION ALL 
        SELECT 4, 'Pension',0,1 UNION ALL 
        SELECT 5, 'Bonds',0,1 UNION ALL 
        SELECT 6, 'Annuities',0,1 UNION ALL 
        SELECT 7, 'Mortgage',0,1 UNION ALL 
        SELECT 8, 'General Insurance',0,1 UNION ALL 
        SELECT 9, 'Collective Investments',0,1 UNION ALL 
        SELECT 10, 'Protection',0,1 UNION ALL 
        SELECT 11, 'Risk Profiler',0,1 UNION ALL 
        SELECT 12, 'Investment Planner',0,1 UNION ALL 
        SELECT 13, 'Retirement Planner',0,1 UNION ALL 
        SELECT 14, 'Portfolio Analyser',0,1 UNION ALL 
        SELECT 15, 'Lifetime Planner',0,1 UNION ALL 
        SELECT 16, 'Cash Account',0,1 UNION ALL 
        SELECT 17, 'Protection Planner',0,1 UNION ALL 
        SELECT 18, 'Pension Freedom Planner',0,1 UNION ALL 
        SELECT 19, 'Multi-Benefit',0,1 UNION ALL 
        SELECT 20, 'PHI',0,1 
 
        SET IDENTITY_INSERT TRefProductGroup OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '79BC0AB4-9C99-47EE-9FCF-95058642F912', 
         'Initial load (20 total rows, file 1 of 1) for table TRefProductGroup',
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
-- #Rows Exported: 20
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
