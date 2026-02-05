SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
	CREATE PROCEDURE [dbo].[SpNAuditQuoteItemRecommendationStatus]
		@StampUser varchar (255),
		@QuoteItemRecommendationStatusId bigint,
		@StampAction char(1)
	AS
		INSERT INTO TQuoteItemRecommendationStatusAudit
		 (QuoteItemId
		  ,QuoteResultId
		  ,RefRecommendationStatusId
		  ,StatusDate
		  ,ConcurrencyId
		  ,RefSolutionStatusId
		  ,SolutionStatusDate
		  ,StampAction
		  ,StampDateTime
		  ,StampUser
		  ,FinancialPlanningSessionId
		  ,RejectReasonId
		  ,RejectReasonNote
		  ,DeferReasonId
		  ,DeferReasonNote
		  ,CreationDate
		  ,PolicyBusinessId
		  ,RecommendationName 
		  ) 
		SELECT QuoteItemId
		  ,QuoteResultId
		  ,RefRecommendationStatusId
		  ,StatusDate
		  ,ConcurrencyId
		  ,RefSolutionStatusId
		  ,SolutionStatusDate
		  ,@StampAction
		  ,GetDate()
		  ,@StampUser
	      	  ,FinancialPlanningSessionId
	      	  ,RejectReasonId
	      	  ,RejectReasonNote
	      	  ,DeferReasonId
		  ,DeferReasonNote
		  ,CreationDate
		  ,PolicyBusinessId
		  ,RecommendationName
		FROM TQuoteItemRecommendationStatus
		WHERE QuoteItemRecommendationStatusId = @QuoteItemRecommendationStatusId

		IF @@ERROR != 0 GOTO errh
			RETURN (0)
		errh:
		RETURN (100)
GO