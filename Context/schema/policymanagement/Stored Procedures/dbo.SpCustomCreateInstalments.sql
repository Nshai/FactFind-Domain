SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpCustomCreateInstalments]
@CurrentUserDate datetime
AS
SET NOCOUNT ON

DECLARE @tx INT
SELECT	@tx = @@TRANCOUNT
IF @tx = 0 
	BEGIN TRANSACTION TX

	DECLARE @feecursorId BIGINT

--Sp variables. 
	DECLARE	@RC			INT
			,@feeId		BIGINT       			

	BEGIN

	-- STEP 1 : SELECT ELIGIBLE FEE RECORDS 
				-- FIND THE FEES THAT ARE DUE IN THE LAST 7 DAYS
				-- FIND THE FEES FOR WHCIH THE INSTALMENT NEEDS TO CALCULATED
	CREATE TABLE #EligibleFeeRecords	(FeeId BIGINT)      
	                                 
	INSERT INTO #EligibleFeeRecords
				(FeeId)
	SELECT 
		Fee.FeeId
	FROM TFee Fee
		INNER JOIN -- With current fee status.
			(
				SELECT FeeId, [Status]
				FROM policymanagement..TFeeStatus 
				WHERE FeeStatusId In 
					(
						SELECT MAX(FeeStatusId) -- To find the current status of the fee.
						FROM policymanagement..TFeeStatus						 
						GROUP BY FeeId
					)
					AND [Status] != 'Cancelled' -- Once the fee is cancelled instalments should not be calculated.
			) FS 
			ON Fee.FeeId = FS.FeeId And Fee.IsRecurring = 1
		INNER JOIN TFeeInstalment FI 
		ON FI.FeeId = Fee.FeeId						
	WHERE 		
		FI.NextInstalmentDate <= @CurrentUserDate AND FI.NextInstalmentDate > DateAdd(dd,-7,@CurrentUserDate) 
		AND FI.InstalmentCount < Fee.NumRecurringPayments
	
	-- STEP 2: LOOP THROUGH EACH FEE TO CALCULATE NEXT DUE DATE
	DECLARE fee_cursor CURSOR 
	FOR SELECT DISTINCT FeeId 
	FROM #EligibleFeeRecords
	
	OPEN fee_cursor
	FETCH NEXT FROM fee_cursor 
	INTO @feecursorId

	WHILE @@FETCH_STATUS = 0
	BEGIN	    
		
		DECLARE @nextdueDate			DATETIME
				,@StartDate				DATETIME
				,@lastDueDate			DATETIME
				,@TotalInstalmentCount	INT
				,@CurrentInstalmentCount INT		
				
		SELECT @TotalInstalmentCount = NumRecurringPayments,@StartDate = StartDate
		FROM TFee
		WHERE FeeId = @feecursorId
				
		SELECT @CurrentInstalmentCount = InstalmentCount,@lastDueDate = NextInstalmentDate
		FROM TFeeInstalment
		WHERE FeeId = @feecursorId
				
		-- STEP 3: UPDATE THE TFEE INSTALMENT RECORD WITH THE NEXT DUE DATE
		IF(@CurrentInstalmentCount < @TotalInstalmentCount)
			BEGIN
				
				EXEC Policymanagement.dbo.SpInstalmentDueDate @feecursorId,@StartDate,@lastDueDate,@CurrentUserDate,@nextdueDate OUTPUT 
				
				UPDATE TFeeInstalment
				SET NextInstalmentDate = @nextdueDate, InstalmentCount = @CurrentInstalmentCount + 1
				WHERE FeeId = @feecursorId
			END		
		
		-- CREATE THE AUDIT RECORD FOR UPDATE.
		INSERT INTO TFeeInstalmentAudit 
					(FeeId, NextInstalmentDate,ConcurrencyId,InstalmentCount,
					 FeeInstalmentId, StampAction, StampDateTime, StampUser) 
		SELECT FeeId, 
			   NextInstalmentDate,ConcurrencyId,InstalmentCount,
		       FeeInstalmentId, 'U', GetDate(), 0
		FROM TFeeInstalment
		WHERE FeeId = @feecursorId
				    
		FETCH NEXT FROM fee_cursor 
		INTO @feecursorId
	    			    
	END

	Close fee_cursor
	DEALLOCATE fee_cursor;

END

IF @@ERROR != 0 GOTO errh

IF @tx = 0 COMMIT TRANSACTION TX

RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)


GO
