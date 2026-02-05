 
-----------------------------------------------------------------------------
-- Table: Administration.TMortgageChecklistQuestion
--    Join: 
--   Where: WHERE TenantId=12498
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '49369A4F-675E-45C1-887D-51ED8F096642'
     AND TenantId = 12498
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TMortgageChecklistQuestion ON; 
 
        INSERT INTO TMortgageChecklistQuestion([MortgageChecklistQuestionId], [Question], [MortgageChecklistCategoryId], [Ordinal], [IsArchived], [TenantId], [ParentQuestionId], [SystemFG], [ConcurrencyId])
        SELECT 76052, 'Key messages about the service being offered have been disclosed and discussed with the client',9936,1,0,12498,NULL,1,1 UNION ALL 
        SELECT 76053, 'The different types of products and interest rate arrangements that might meet your customer''s future needs (including what your customer''s future repayments will be after a concessionary scheme)',9936,2,0,12498,NULL,1,1 UNION ALL 
        SELECT 76054, 'The main repayment methods available',9936,3,0,12498,NULL,1,1 UNION ALL 
        SELECT 76055, 'For mortgages based in part or in full on an interest only basis:',9936,4,0,12498,NULL,1,1 UNION ALL 
        SELECT 76056, 'The various methods available for repayment of the loan',9936,1,0,12498,76055,1,1 UNION ALL 
        SELECT 76057, 'The consequences of failing to make suitable arrangements for the repayment of the mortgage',9936,2,0,12498,76055,1,1 UNION ALL 
        SELECT 76058, 'Confirm that it is the customer''s responsibility to ensure that a repayment vehicle is maintained for the duration of the mortgage',9936,3,0,12498,76055,1,1 UNION ALL 
        SELECT 76059, 'Client is aware that they will have to demonstrate to the Lender that a clearly understood and credible repayment strategy is in place',9936,4,0,12498,76055,1,1 UNION ALL 
        SELECT 76060, 'The consequences should they repay the mortgage early',9936,5,0,12498,NULL,1,1 UNION ALL 
        SELECT 76061, 'Related insurances',9936,6,0,12498,NULL,1,1 UNION ALL 
        SELECT 76062, 'The customer''s responsibility to ensure that all necessary forms of insurance relating to the property and mortgage are in place',9936,7,0,12498,NULL,1,1 UNION ALL 
        SELECT 76063, 'Explain that certain insurances may be a condition of the mortgage',9936,8,0,12498,NULL,1,1 UNION ALL 
        SELECT 76064, 'All costs and fees associated with the mortgage',9936,9,0,12498,NULL,1,1 UNION ALL 
        SELECT 76065, 'Whether or not the terms and conditions of the mortgage product are portable in the event of moving house',9936,10,0,12498,NULL,1,1 UNION ALL 
        SELECT 76066, 'Explain when the customer''s account details may be passed to a credit reference agency',9936,11,0,12498,NULL,1,1 UNION ALL 
        SELECT 76067, 'Explain what a higher lending charge is',9936,12,0,12498,NULL,1,1 UNION ALL 
        SELECT 76068, 'The possible consequences for the customer''s mortgage should their personal circumstances change (e.g. accident, sickness, redundancy) and the options open to them (e.g. Mortgage Payment Protection)',9936,13,0,12498,NULL,1,1 UNION ALL 
        SELECT 76069, 'Joint applications - concept of joint and several liability',9936,14,0,12498,NULL,1,1 UNION ALL 
        SELECT 76070, 'The implications of adding fees and costs to the loan / or of debt consolidation',9936,15,0,12498,NULL,1,1 UNION ALL 
        SELECT 76071, 'You have considered and discussed why it is not appropriate for the client to take out a mortgage which is not a bridging loan',9937,1,0,12498,NULL,1,1 UNION ALL 
        SELECT 76072, 'Client is aware that they will have to demonstrate to the Lender that a clearly understood and credible repayment strategy is in place',9937,2,0,12498,NULL,1,1 UNION ALL 
        SELECT 76073, 'Client has confirmed in writing that they are aware of the consequences of losing the protections of the rules on suitability and have made a positive election to proceed with an execution-only sale',9938,1,0,12498,NULL,1,1 UNION ALL 
        SELECT 76074, 'Client has identified the product that they require, and has specified the Lender, interest rate, rate type, Purchase Price, loan amount, the term of the mortgage and repayment basis (except High Net Worth clients and clients completing contract variations)',9938,2,0,12498,NULL,1,1 
 
        SET IDENTITY_INSERT TMortgageChecklistQuestion OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '49369A4F-675E-45C1-887D-51ED8F096642', 
         'Initial load (23 total rows, file 1 of 1) for table TMortgageChecklistQuestion',
         12498, 
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
-- #Rows Exported: 23
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
