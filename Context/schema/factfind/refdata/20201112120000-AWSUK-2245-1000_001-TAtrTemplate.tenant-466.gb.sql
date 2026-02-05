 
-----------------------------------------------------------------------------
-- Table: FactFind.TAtrTemplate
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'DDDD3193-25A7-4B71-8563-671B2D8BF9E7'
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
        SET IDENTITY_INSERT TAtrTemplate ON; 
 
        INSERT INTO TAtrTemplate([AtrTemplateId], [Identifier], [Descriptor], [Active], [HasModels], [BaseAtrTemplate], [AtrRefPortfolioTypeId], [IndigoClientId], [Guid], [IsArchived], [ConcurrencyId], [HasFreeTextAnswers])
        SELECT 335, 'Five Profiles', '',0,0,NULL,NULL,466,'C029D6F7-D7C7-4C61-9A98-DA62945FE6C1',0,1,0 UNION ALL 
        SELECT 336, 'Five Profiles (With Model Portfolios)', '',0,1,NULL,NULL,466,'CF1FD26B-875D-4F86-9908-405BFAC21C84',0,1,0 UNION ALL 
        SELECT 337, 'Ten Profiles', '',0,0,NULL,NULL,466,'AF78842B-99B6-4EE1-8457-47B917CFA0C8',0,1,0 UNION ALL 
        SELECT 338, 'Ten Profiles (With Model Portfolios)', '',0,1,NULL,NULL,466,'4D5499D3-5FAD-4D6C-9052-E17D2FBE70AD',0,1,0 UNION ALL 
        SELECT 2717, 'eValueFE 18 question (revised) 10 profile with asset models', '',0,1,NULL,NULL,466,'FD599F18-DD7E-41FD-9798-B520520D2B61',0,1,0 UNION ALL 
        SELECT 2809, 'eValueFE 13 question 5 profile', '',0,0,NULL,NULL,466,'8C93A7CE-3931-4CB5-9D96-6A130E8F37B8',0,1,0 UNION ALL 
        SELECT 2811, 'eValueFE 13 question 5 profile with asset models', '',0,1,NULL,NULL,466,'2B128DA8-539A-4681-847B-6F9680F474B6',0,1,0 UNION ALL 
        SELECT 2718, 'eValueFE 18 question (revised) 10 profile with asset models', '',0,1,NULL,NULL,466,'47D79A15-68DD-46DE-97EA-79E327EB6636',1,1,0 UNION ALL 
        SELECT 2810, 'eValueFE 18 question 10 profile', '',0,0,NULL,NULL,466,'136E7C5C-F177-4093-8D7E-027CB663B785',0,1,0 UNION ALL 
        SELECT 2812, 'eValueFE 18 question 10 profile with asset models', '',0,1,NULL,NULL,466,'75F4708D-EC93-4C57-A6DF-0269BB24B82E',0,1,0 UNION ALL 
        SELECT 6307, 'eValueFE 13 question 5 profile (2014 latest)', NULL,1,0,NULL,NULL,466,'27730FDE-BDC3-4D83-9324-3D06CA573CC7',0,1,0 UNION ALL 
        SELECT 6308, 'eValueFE 13 question 5 profile (2014 latest) with asset models', NULL,1,1,NULL,NULL,466,'3F9A3F08-0E82-4085-9DD1-D8BD53336D35',0,1,0 UNION ALL 
        SELECT 6309, 'eValueFE 18 question 10 profile (2014 latest)', NULL,1,0,NULL,NULL,466,'0D20E9E2-C379-4E06-8922-3C2F2C95719E',0,1,0 UNION ALL 
        SELECT 6310, 'eValueFE 18 question 10 profile (2014 latest) with asset models', NULL,1,1,NULL,NULL,466,'9E3FBB8E-646D-41BA-A2F3-527525474581',0,1,0 UNION ALL 
        SELECT 8777, 'eValue 15 question 7 profile', '',1,0,NULL,NULL,466,'B50CD81A-F8CE-4DD2-9EDF-A7300096D06F',0,1,0 UNION ALL 
        SELECT 8661, 'eValue 18 Question 10 Profile (No Term) with asset models', '',1,1,NULL,NULL,466,'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',0,1,0 
 
        SET IDENTITY_INSERT TAtrTemplate OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'DDDD3193-25A7-4B71-8563-671B2D8BF9E7', 
         'Initial load (16 total rows, file 1 of 1) for table TAtrTemplate',
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
-- #Rows Exported: 16
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
