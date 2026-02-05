 
-----------------------------------------------------------------------------
-- Table: FactFind.TRefNavigationItem
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '21644FC3-3626-4CD9-91E3-B8F91778D827'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefNavigationItem ON; 
 
        INSERT INTO TRefNavigationItem([RefNavigationItemId], [ConcurrencyId], [Name], [XmlId])
        SELECT 1,1, 'Profile', 'Profile' UNION ALL 
        SELECT 2,1, 'Employment', 'Employment' UNION ALL 
        SELECT 3,1, 'Assets & Liabilities', 'AssetsAndLiabilities' UNION ALL 
        SELECT 4,1, 'Budget', 'Budget' UNION ALL 
        SELECT 5,1, 'Mortgage', 'Mortgage' UNION ALL 
        SELECT 6,1, 'Protection', 'Protection' UNION ALL 
        SELECT 7,1, 'Retirement', 'Retirement' UNION ALL 
        SELECT 8,1, 'Investment', 'Investment' UNION ALL 
        SELECT 9,1, 'Estate Planning', 'EstatePlanning' UNION ALL 
        SELECT 10,1, 'Other Plans (Mortgage Users)', 'OtherPlans' UNION ALL 
        SELECT 11,1, 'Declaration', 'Declaration' 
 
        SET IDENTITY_INSERT TRefNavigationItem OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '21644FC3-3626-4CD9-91E3-B8F91778D827', 
         'Initial load (11 total rows, file 1 of 1) for table TRefNavigationItem',
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
