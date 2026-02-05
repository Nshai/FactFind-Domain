 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefEvalueCashflowType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '1E2BF1C4-8254-4F76-9D27-538D8CD3978C'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefEvalueCashflowType ON; 
 
        INSERT INTO TRefEvalueCashflowType([RefEvalueCashflowTypeId], [EvalueCashflowTypeName], [EvalueCashflowTypeLevel1], [EvalueCashflowTypeLevel2], [EvalueCashflowProductName])
        SELECT 1, 'eventTravel', 'OUTGOING', 'OBJECTIVE', 'Travel & Holidays' UNION ALL 
        SELECT 2, 'eventMortgage', 'OUTGOING', 'OBJECTIVE', 'Mortgage Repayment' UNION ALL 
        SELECT 3, 'eventSelfIndulgence', 'OUTGOING', 'OBJECTIVE', 'Self Indulgence' UNION ALL 
        SELECT 4, 'eventProperty', 'OUTGOING', 'OBJECTIVE', 'Property Purchase' UNION ALL 
        SELECT 5, 'eventEducation', 'OUTGOING', 'OBJECTIVE', 'Education' UNION ALL 
        SELECT 6, 'eventOther', 'OUTGOING', 'OBJECTIVE', 'Other' UNION ALL 
        SELECT 7, 'utilities', 'OUTGOING', 'NORMAL', 'Utilities' UNION ALL 
        SELECT 8, 'Telephone_broadband', 'OUTGOING', 'NORMAL', 'Telephone/broadband' UNION ALL 
        SELECT 9, 'Rent', 'OUTGOING', 'NORMAL', 'Rent' UNION ALL 
        SELECT 10, 'Council_tax', 'OUTGOING', 'NORMAL', 'Council tax' UNION ALL 
        SELECT 11, 'TV', 'OUTGOING', 'NORMAL', 'TV' UNION ALL 
        SELECT 12, 'House_insurance', 'OUTGOING', 'NORMAL', 'House insurance' UNION ALL 
        SELECT 13, 'House_maintenance', 'OUTGOING', 'NORMAL', 'House maintenance' UNION ALL 
        SELECT 14, 'Fuel', 'OUTGOING', 'NORMAL', 'Fuel' UNION ALL 
        SELECT 15, 'Car_tax_insurance', 'OUTGOING', 'NORMAL', 'Car tax/insurance' UNION ALL 
        SELECT 16, 'Car_maintenance', 'OUTGOING', 'NORMAL', 'Car maintenance' UNION ALL 
        SELECT 17, 'Public_transport', 'OUTGOING', 'NORMAL', 'Public transport' UNION ALL 
        SELECT 18, 'General_insurance', 'OUTGOING', 'NORMAL', 'General insurance' UNION ALL 
        SELECT 19, 'Private_medical', 'OUTGOING', 'NORMAL', 'Private medical' UNION ALL 
        SELECT 20, 'Pets', 'OUTGOING', 'NORMAL', 'Pets' UNION ALL 
        SELECT 21, 'Childcare', 'OUTGOING', 'NORMAL', 'Childcare' UNION ALL 
        SELECT 22, 'Elderly_care', 'OUTGOING', 'NORMAL', 'Elderly care' UNION ALL 
        SELECT 23, 'High_Street', 'OUTGOING', 'NORMAL', 'High Street' UNION ALL 
        SELECT 24, 'Online', 'OUTGOING', 'NORMAL', 'Online' UNION ALL 
        SELECT 25, 'Holidays', 'OUTGOING', 'NORMAL', 'Holidays' UNION ALL 
        SELECT 26, 'Entertainment', 'OUTGOING', 'NORMAL', 'Entertainment' UNION ALL 
        SELECT 27, 'Clubs_subscriptions', 'OUTGOING', 'NORMAL', 'Clubs & subscriptions' UNION ALL 
        SELECT 28, 'Alcohol_tobacco', 'OUTGOING', 'NORMAL', 'Alcohol & tobacco' UNION ALL 
        SELECT 29, 'Sport', 'OUTGOING', 'NORMAL', 'Sport' UNION ALL 
        SELECT 30, 'Spending_cash', 'OUTGOING', 'NORMAL', 'Spending cash' UNION ALL 
        SELECT 31, 'Food_household', 'OUTGOING', 'NORMAL', 'Food & household' UNION ALL 
        SELECT 32, 'Restaurant_takeaways', 'OUTGOING', 'NORMAL', 'Restaurant/takeaways' UNION ALL 
        SELECT 33, 'Other', 'OUTGOING', 'NORMAL', 'Other' UNION ALL 
        SELECT 34, 'eventIncome', 'OUTGOING', 'OBJECTIVE', 'Income' 
 
        SET IDENTITY_INSERT TRefEvalueCashflowType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '1E2BF1C4-8254-4F76-9D27-538D8CD3978C', 
         'Initial load (34 total rows, file 1 of 1) for table TRefEvalueCashflowType',
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
-- #Rows Exported: 34
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
