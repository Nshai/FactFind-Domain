SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spSetAdditionalRiskQuestions] @TenantId bigint, @StampUser varchar(255) = '-1010'
as
begin
  if exists(select 1 from FactFind.dbo.TAdditionalRiskQuestion 
			where TenantId = @TenantId and QuestionNumber = 1 and QuestionText = 'Is this investment a significant proportion of your total wealth?')
	begin
		raiserror('ERROR: Additional Risk Questions already configured',0,1) with nowait
		return
  end

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE 
	@starttrancount int,
	@ErrorSeverity INT,
	@ErrorState INT,
	@ErrorLine INT,
	@ErrorNumber INT,
	@ErrorMessage VARCHAR(MAX)

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

		    -- BEGIN DATA INSERT/UPDATE
			INSERT INTO FactFind.dbo.TAdditionalRiskQuestion (TenantId, QuestionNumber, QuestionText) 
				OUTPUT 
				inserted.AdditionalRiskQuestionId, 
				inserted.TenantId, 
				inserted.QuestionNumber, 
				inserted.QuestionText,
				'C', GETDATE(), @StampUser
			INTO FactFind.dbo.TAdditionalRiskQuestionAudit(
				AdditionalRiskQuestionId,
				TenantId,
				QuestionNumber,
				QuestionText, 
				StampAction, StampDateTime, StampUser)
			SELECT @TenantId, A.QuestionNumber, A.QuestionText
				FROM (
					SELECT 1 AS QuestionNumber, N'Is this investment a significant proportion of your total wealth?' AS QuestionText
					UNION ALL
					SELECT 2 AS QuestionNumber, N'Is this investment providing your daily living expenses?' AS QuestionText
					UNION ALL
					SELECT 3 AS QuestionNumber, N'Would you need the money being invested to cover your expenses in an emergency?' AS QuestionText
					UNION ALL
					SELECT 4 AS QuestionNumber, N'Do you have any dependants who rely on you financially?' AS QuestionText
					UNION ALL
					SELECT 5 AS QuestionNumber, N'Do you have any major financial commitments that could mean you need to access this money earlier than you currently think?' AS QuestionText
					UNION ALL
					SELECT 6 AS QuestionNumber, N'Are you experienced in investing?' AS QuestionText
					) A
				ORDER BY A.QuestionNumber

			
    IF @starttrancount = 0 
        COMMIT TRANSACTION

END TRY
BEGIN CATCH

       SELECT @ErrorMessage = ERROR_MESSAGE(),
       @ErrorSeverity = ERROR_SEVERITY(),
       @ErrorState = ERROR_STATE(),
       @ErrorNumber = ERROR_NUMBER(),
       @ErrorLine = ERROR_LINE()

       /*Insert into logging table - IF ANY	*/

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION
    
       RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine) with nowait

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF
end

GO
