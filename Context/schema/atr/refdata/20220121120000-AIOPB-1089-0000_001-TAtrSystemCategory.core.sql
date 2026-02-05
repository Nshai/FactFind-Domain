 
-----------------------------------------------------------------------------
-- Table: ATR.TAtrSystemCategory
-----------------------------------------------------------------------------
USE ATR

DECLARE @MyGuid UNIQUEIDENTIFIER = 'EA513F58-8B68-46D7-AC09-FDD34060A6B4'

-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = @MyGuid
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TAtrSystemCategory ON; 
 
        INSERT INTO TAtrSystemCategory([Id], [Type], [Name], [Value])
		VALUES 
			 (1, 'QuestionCategory', 'FinancialSecurity', 'Financial Security')
			,(2, 'QuestionCategory', 'InvestmentExperience', 'Investment Experience')
			,(3, 'QuestionCategory', 'LiquidityNeeds', 'Liquidity Needs')
			,(4, 'QuestionCategory', 'InvestmentObjective', 'Investment Objective')
			,(5, 'QuestionCategory', 'TimeHorizonToWithdrawal', 'Time Horizon to Withdrawal')
			,(6, 'QuestionCategory', 'TimeHorizonTotal', 'Time Horizon Total')
			,(7, 'RiskTolerance', 'RiskTolerance', 'Risk Tolerance')
 
        SET IDENTITY_INSERT TAtrSystemCategory OFF;
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         @MyGuid, 
         'Initial load (7 total rows, file 1 of 1) for table TAtrSystemCategory',
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
