 
-----------------------------------------------------------------------------
-- Table: FactFind.TAtrTemplateCombined
--    Join: join TAtrTemplate t on t.Guid = TAtrTemplateCombined.Guid
--   Where: WHERE t.IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '14B4DE6B-314F-4BE9-A866-6A2B3E139C05'
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
 
        INSERT INTO TAtrTemplateCombined([Guid], [AtrTemplateId], [Identifier], [Descriptor], [Active], [HasModels], [BaseAtrTemplate], [AtrRefPortfolioTypeId], [IndigoClientId], [IndigoClientGuid], [IsArchived], [ConcurrencyId], [msrepl_tran_version], [HasFreeTextAnswers])
        SELECT 'C029D6F7-D7C7-4C61-9A98-DA62945FE6C1',335, 'Five Profiles', '',0,0,NULL,NULL,466,'9D7C163A-1166-45E9-B9E7-712388CE038E',0,1,'49FCC77C-6489-45D0-9BA6-E2A7CD3E6760',0 UNION ALL 
        SELECT 'CF1FD26B-875D-4F86-9908-405BFAC21C84',336, 'Five Profiles (With Model Portfolios)', '',0,1,NULL,NULL,466,'9D7C163A-1166-45E9-B9E7-712388CE038E',0,1,'D1C90902-5BC5-4B8E-B552-92F0A60EDAA4',0 UNION ALL 
        SELECT 'AF78842B-99B6-4EE1-8457-47B917CFA0C8',337, 'Ten Profiles', '',0,0,NULL,NULL,466,'9D7C163A-1166-45E9-B9E7-712388CE038E',0,1,'450296AA-46D0-4A27-935F-DA1EC7271548',0 UNION ALL 
        SELECT '4D5499D3-5FAD-4D6C-9052-E17D2FBE70AD',338, 'Ten Profiles (With Model Portfolios)', '',0,1,NULL,NULL,466,'9D7C163A-1166-45E9-B9E7-712388CE038E',0,1,'4D525287-A09D-442C-B663-74A6BFF814E4',0 UNION ALL 
        SELECT 'FD599F18-DD7E-41FD-9798-B520520D2B61',2717, 'eValueFE 18 question (revised) 10 profile with asset models', '',0,1,NULL,NULL,466,'9D7C163A-1166-45E9-B9E7-712388CE038E',0,1,'79097923-6639-4712-905A-77D267E5DDD3',0 UNION ALL 
        SELECT '8C93A7CE-3931-4CB5-9D96-6A130E8F37B8',2809, 'eValueFE 13 question 5 profile', '',0,0,NULL,NULL,466,'9D7C163A-1166-45E9-B9E7-712388CE038E',0,1,'C6347913-20CE-4B6B-822C-92D622C781E5',0 UNION ALL 
        SELECT '2B128DA8-539A-4681-847B-6F9680F474B6',2811, 'eValueFE 13 question 5 profile with asset models', '',0,1,NULL,NULL,466,'9D7C163A-1166-45E9-B9E7-712388CE038E',0,1,'51FD9100-C53D-4196-8443-E005DF39FC62',0 UNION ALL 
        SELECT '47D79A15-68DD-46DE-97EA-79E327EB6636',2718, 'eValueFE 18 question (revised) 10 profile with asset models', '',0,1,NULL,NULL,466,'9D7C163A-1166-45E9-B9E7-712388CE038E',1,1,'84703913-DAC1-4470-B19E-32FCB349992C',0 UNION ALL 
        SELECT '136E7C5C-F177-4093-8D7E-027CB663B785',2810, 'eValueFE 18 question 10 profile', '',0,0,NULL,NULL,466,'9D7C163A-1166-45E9-B9E7-712388CE038E',0,1,'0DE2DFF5-E5C7-47BD-ADDB-FE977D475358',0 UNION ALL 
        SELECT '75F4708D-EC93-4C57-A6DF-0269BB24B82E',2812, 'eValueFE 18 question 10 profile with asset models', '',0,1,NULL,NULL,466,'9D7C163A-1166-45E9-B9E7-712388CE038E',0,1,'9FFF1A37-F606-43A2-9798-6FBE15ACC322',0 UNION ALL 
        SELECT '27730FDE-BDC3-4D83-9324-3D06CA573CC7',6307, 'eValueFE 13 question 5 profile (2014 latest)', NULL,1,0,NULL,NULL,466,'9D7C163A-1166-45E9-B9E7-712388CE038E',0,1,'FB429FFA-061D-487D-9F78-DF56BF4CB09D',0 UNION ALL 
        SELECT '3F9A3F08-0E82-4085-9DD1-D8BD53336D35',6308, 'eValueFE 13 question 5 profile (2014 latest) with asset models', NULL,1,1,NULL,NULL,466,'9D7C163A-1166-45E9-B9E7-712388CE038E',0,1,'4E48256C-A53D-40CD-9479-9BB190F6917D',0 UNION ALL 
        SELECT '0D20E9E2-C379-4E06-8922-3C2F2C95719E',6309, 'eValueFE 18 question 10 profile (2014 latest)', NULL,1,0,NULL,NULL,466,'9D7C163A-1166-45E9-B9E7-712388CE038E',0,1,'92CC02A0-1D00-46D5-889D-A2C7E4B3BB12',0 UNION ALL 
        SELECT '9E3FBB8E-646D-41BA-A2F3-527525474581',6310, 'eValueFE 18 question 10 profile (2014 latest) with asset models', NULL,1,1,NULL,NULL,466,'9D7C163A-1166-45E9-B9E7-712388CE038E',0,1,'32F8D715-78A7-47E5-A873-92257AE1D413',0 UNION ALL 
        SELECT 'B50CD81A-F8CE-4DD2-9EDF-A7300096D06F',8777, 'eValue 15 question 7 profile', '',1,0,NULL,NULL,466,'9D7C163A-1166-45E9-B9E7-712388CE038E',0,1,'AA8D7245-DB5D-4478-81D0-A7C7AA5A7EEA',0 UNION ALL 
        SELECT 'CA2E0E7C-2A68-405B-8B91-A70E01024C5C',8661, 'eValue 18 Question 10 Profile (No Term) with asset models', '',1,1,NULL,NULL,466,'9D7C163A-1166-45E9-B9E7-712388CE038E',0,1,'3953766D-E30B-4F0A-9EB7-CEB39904C9B0',0 
 
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '14B4DE6B-314F-4BE9-A866-6A2B3E139C05', 
         'Initial load (16 total rows, file 1 of 1) for table TAtrTemplateCombined',
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
