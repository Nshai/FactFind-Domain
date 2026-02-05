
-----------------------------------------------------------------------------
-- Table: FactFind.TRefExpenditureGroup
--    Join: 
--   Where: 
-----------------------------------------------------------------------------


USE FactFind


-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '434F10C9-2805-44A3-B30A-A1ADE8B5462F'
) RETURN 

SET NOCOUNT ON 
SET XACT_ABORT ON

DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION

        -- insert the records
        SET IDENTITY_INSERT TRefExpenditureGroup ON; 

        INSERT INTO TRefExpenditureGroup([RefExpenditureGroupId], [ConcurrencyId], [Name], [Ordinal], [IsConsolidateEnabled])
        SELECT 3,1, 'Liability Expenditure',4,1 UNION ALL 
        SELECT 2,1, 'Non-Essential Outgoings',3,0 UNION ALL 
        SELECT 1,1, 'Basic Essential Expenditure',1,0 UNION ALL 
        SELECT 4,1, 'Basic Quality of Living',2,0 UNION ALL
        SELECT 5,1, 'Expenditures', 5, 0

        SET IDENTITY_INSERT TRefExpenditureGroup OFF

        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '434F10C9-2805-44A3-B30A-A1ADE8B5462F', 
         'Initial load (4 total rows, file 1 of 1) for table TRefExpenditureGroup',
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
-- #Rows Exported: 5
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------