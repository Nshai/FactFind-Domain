SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomUpdateIsCompleteForSession]	
	@FinancialPlanningId bigint,
	@StampUser varchar(255)
AS

INSERT 
	INTO Factfind..TFinancialPlanningSessionAudit(
						FinancialPlanningId
						,FactFindId
						,CRMContactId
						,[Description]
						,[Date]
						,RefFinancialPlanningSessionStatusId
						,UserId
						,OpportunityId
						,DocumentId
						,ConcurrencyId
						,FinancialPlanningSessionId
						,SessionId
						,IsCompleted
						,CRMContactId2
						,ServiceCaseId
						,FeeModelId
						,InitialFeePercentage
						,OngoingFeePercentage
						,StampAction
						,StampDateTime
						,StampUser)
	SELECT 
		FinancialPlanningId
		,FactFindId
		,CRMContactId
		,[Description]
		,[Date]
		,RefFinancialPlanningSessionStatusId
		,UserId
		,OpportunityId
		,DocumentId
		,ConcurrencyId
		,FinancialPlanningSessionId
		,SessionId
		,IsCompleted
		,CRMContactId2
		,ServiceCaseId
		,FeeModelId
		,InitialFeePercentage
		,OngoingFeePercentage
		,'U'
		,GetDate()
		,@StampUser
	FROM 
		Factfind..TFinancialPlanningSession
	WHERE 
		FinancialPlanningId = @FinancialPlanningId 

	UPDATE 
		Factfind..TFinancialPlanningSession
	SET IsCompleted = 1
	WHERE 
		FinancialPlanningId = @FinancialPlanningId 
