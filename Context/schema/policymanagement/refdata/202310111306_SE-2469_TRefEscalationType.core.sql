USE [policymanagement];

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
/*
Summary
Adding CPI to the escalation type in GB/AU/US regions.
DatabaseName            TableName                       Expected Rows
policymanagement        dbo.TRefEscalationType			1
*/

SELECT 
    @ScriptGUID = '1F5F5992-887B-4F1E-B55C-891DB980CD23', 
    @Comments = 'SE-2469: Adding CPI to the escalation type [EPIC-2417]'  


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount INT
        , @RefEscalationTypeId INT = 6
		, @EscalationType VARCHAR(10) = 'CPI'
		, @RetireFg INT = 0
		, @TimeStamp DATETIME = GETUTCDATE()
		, @ConcurrencyId INT = 1

BEGIN TRY

    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

            -- BEGIN DATA INSERT

            SET IDENTITY_INSERT dbo.TRefEscalationType ON

			INSERT dbo.TRefEscalationType
					([RefEscalationTypeId]
					,[EscalationType]
					,[RetireFg]
					,[ConcurrencyId])
			OUTPUT
					inserted.[EscalationType]
					,inserted.[RetireFg]
					,inserted.[ConcurrencyId]
					,inserted.[RefEscalationTypeId]
					,'C'
					,@TimeStamp
					,'0'
			INTO [dbo].[TRefEscalationTypeAudit]
					([EscalationType]
					,[RetireFg]
					,[ConcurrencyId]
					,[RefEscalationTypeId]
					,[StampAction]
					,[StampDateTime]
					,[StampUser])    
			VALUES  (@RefEscalationTypeId
					,@EscalationType
					,@RetireFg
					,@ConcurrencyId);
		
			SET IDENTITY_INSERT dbo.TRefEscalationType OFF

			   -- END DATA INSERT

			INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

			IF @starttrancount = 0 
				COMMIT TRANSACTION

END TRY
BEGIN CATCH

    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT
    DECLARE @ErrorLine INT
    DECLARE @ErrorNumber INT

    SELECT @ErrorMessage = ERROR_MESSAGE(),
    @ErrorSeverity = ERROR_SEVERITY(),
    @ErrorState = ERROR_STATE(),
    @ErrorNumber = ERROR_NUMBER(),
    @ErrorLine = ERROR_LINE()

    /*Insert into logging table - IF ANY	*/

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;