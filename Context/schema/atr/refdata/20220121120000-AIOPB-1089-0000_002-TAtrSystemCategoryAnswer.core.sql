 
-----------------------------------------------------------------------------
-- Table: ATR.TAtrSystemCategoryAnswer
-----------------------------------------------------------------------------
USE ATR

DECLARE @MyGuid UNIQUEIDENTIFIER = '3F917089-0975-4F36-AB0A-FD66AC93CB07'

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
        SET IDENTITY_INSERT TAtrSystemCategoryAnswer ON; 
 
        INSERT INTO TAtrSystemCategoryAnswer([Id], [AtrSystemCategoryId], [Name], [Value])
		VALUES 
			 (1, 1, 'High', 'High')
			,(2, 1, 'Medium', 'Medium')
			,(3, 1, 'Low', 'Low')
			,(4, 1, 'None', 'None')
			,(5, 2, 'High', 'High')
			,(6, 2, 'Medium', 'Medium')
			,(7, 2, 'Low', 'Low')
			,(8, 2, 'None', 'None')
			,(9, 3, 'High', 'High')
			,(10, 3, 'Medium', 'Medium')
			,(11, 3, 'Low', 'Low')
			,(12, 3, 'None', 'None')
			,(13, 4, 'Stability', 'Stability')
			,(14, 4, 'Income', 'Income')
			,(15, 4, 'BalanceOfIncomeAndGrowth', 'Balance of Income and Growth')
			,(16, 4, 'Growth', 'Growth')
			,(17, 4, 'HighGrwoth', 'High Growth')
			,(18, 5, '1', '1' )
			,(19, 5, '2', '2')
			,(20, 5, '3', '3')
			,(21, 5, '4', '4')
			,(22, 5, '5', '5')
			,(23, 5, '6', '6')
			,(24, 5, '7', '7')
			,(25, 5, '8', '8')
			,(26, 5, '9', '9')
			,(27, 5, '10', '10')
			,(28, 5, '11-15', '11-15')
			,(29, 5, '16-20', '16-20')
			,(30, 5, '21-25', '21-25')
			,(31, 5, '25+', '25+')
			,(32, 6, '0-5', '0-5')
			,(33, 6, '6-10', '6-20')
			,(34, 6, '11-15', '11-15')
			,(35, 6, '16-20', '16-20')
			,(36, 6, '21-25', '21-25')
			,(37, 6, '26-30', '26-30')
			,(38, 6, '30+', '30+')
			,(39, 7, 'Low', 'Low')
			,(40, 7, 'LowToModerate', 'Low to Moderate')
			,(41, 7, 'Moderate', 'Moderate')
			,(42, 7, 'ModerateToHigh', 'Moderate to High')
			,(43, 7, 'High', 'High')

        SET IDENTITY_INSERT TAtrSystemCategoryAnswer OFF;
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         @MyGuid, 
         'Initial load (43 total rows, file 1 of 1) for table TAtrSystemCategoryAnswer',
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
