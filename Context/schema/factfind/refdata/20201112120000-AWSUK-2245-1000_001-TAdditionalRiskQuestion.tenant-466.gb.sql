 
-----------------------------------------------------------------------------
-- Table: FactFind.TAdditionalRiskQuestion
--    Join: 
--   Where: WHERE TenantId=466
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'D0C9CC45-B449-40BF-B642-01E86FE7238C'
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
        SET IDENTITY_INSERT TAdditionalRiskQuestion ON; 
 
        INSERT INTO TAdditionalRiskQuestion([AdditionalRiskQuestionId], [TenantId], [QuestionNumber], [QuestionText])
        SELECT 1929,466,1, 'Is this investment a significant proportion of your total wealth?' UNION ALL 
        SELECT 1930,466,2, 'Is this investment providing your daily living expenses?' UNION ALL 
        SELECT 1931,466,3, 'Would you need the money being invested to cover your expenses in an emergency?' UNION ALL 
        SELECT 1932,466,4, 'Do you have any dependants who rely on you financially?' UNION ALL 
        SELECT 1933,466,5, 'Do you have any major financial commitments that could mean you need to access this money earlier than you currently think?' UNION ALL 
        SELECT 1934,466,6, 'Are you experienced in investing?' 
 
        SET IDENTITY_INSERT TAdditionalRiskQuestion OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'D0C9CC45-B449-40BF-B642-01E86FE7238C', 
         'Initial load (6 total rows, file 1 of 1) for table TAdditionalRiskQuestion',
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
-- #Rows Exported: 6
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
