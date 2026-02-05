 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefAdverseCredit
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'A4C07A4D-F6D6-4799-B87B-1EB43E590C48'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefAdverseCredit ON; 
 
        INSERT INTO TRefAdverseCredit([RefAdverseCreditId], [Name], [ConcurrencyId])
        SELECT 1, 'Bankruptcy/IVA',1 UNION ALL 
        SELECT 2, 'CCJ/Default',1 UNION ALL 
        SELECT 3, 'Mortgage Arrears',1 UNION ALL 
        SELECT 4, 'Other Liabilities Arrears',1 UNION ALL 
        SELECT 5, 'Repossession',1 
 
        SET IDENTITY_INSERT TRefAdverseCredit OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'A4C07A4D-F6D6-4799-B87B-1EB43E590C48', 
         'Initial load (5 total rows, file 1 of 1) for table TRefAdverseCredit',
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
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
