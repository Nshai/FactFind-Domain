SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
	CREATE PROCEDURE [dbo].[SpNAuditManualRecommendation]
		@StampUser varchar (255),
		@ManualRecommendationId bigint,
		@StampAction char(1)
	AS
		INSERT INTO TManualRecommendationAudit 
		 (ManualRecommendationId, IndigoClientId, FinancialPlanningSessionId, 
		  RefRecommendationSolutionStatusId, ModificationDate,
		  StampAction, StampDateTime, StampUser, CreationDate, RecommendationName) 
		SELECT ManualRecommendationId, IndigoClientId, FinancialPlanningSessionId,
		       RefRecommendationSolutionStatusId, ModificationDate, 
		  @StampAction, GetDate(), @StampUser, CreationDate, RecommendationName
		FROM TManualRecommendation
		WHERE ManualRecommendationId = @ManualRecommendationId

		IF @@ERROR != 0 GOTO errh
			RETURN (0)
		errh:
		RETURN (100)
GO


