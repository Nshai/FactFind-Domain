 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TAttributeList
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '567F41CE-98AD-44EF-84C6-08AEDD539555'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TAttributeList ON; 
 
        INSERT INTO TAttributeList([AttributeListId], [Name], [Type], [ConcurrencyId])
        SELECT 18, 'MVR Free Date', 'Date',1 UNION ALL 
        SELECT 17, 'Income or Growth', 'List',1 UNION ALL 
        SELECT 16, 'Level of Income', 'Currency',1 UNION ALL 
        SELECT 15, 'Level of Cover', 'Currency',1 UNION ALL 
        SELECT 14, 'Is Secured?', 'List',1 UNION ALL 
        SELECT 13, 'Amount Released', 'Currency',1 UNION ALL 
        SELECT 12, 'Has unemployment cover', 'List',2 UNION ALL 
        SELECT 11, 'Policy Level', 'List',1 UNION ALL 
        SELECT 10, 'Mortgage Payment', 'List',1 UNION ALL 
        SELECT 9, 'Term Type', 'List',1 UNION ALL 
        SELECT 8, '', 'Check',1 UNION ALL 
        SELECT 7, '', 'Check',1 UNION ALL 
        SELECT 6, '', 'Check',1 UNION ALL 
        SELECT 5, 'Wrapper Only', 'List',1 UNION ALL 
        SELECT 4, 'Annuity', 'List',1 UNION ALL 
        SELECT 3, 'Is the scheme in conjunction with a pension fund withdrawal', 'List',1 UNION ALL 
        SELECT 2, 'Is plan running concurrently with another pension', 'List',1 UNION ALL 
        SELECT 1, 'Fund Category', 'Check',1 
 
        SET IDENTITY_INSERT TAttributeList OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '567F41CE-98AD-44EF-84C6-08AEDD539555', 
         'Initial load (18 total rows, file 1 of 1) for table TAttributeList',
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
-- #Rows Exported: 18
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
