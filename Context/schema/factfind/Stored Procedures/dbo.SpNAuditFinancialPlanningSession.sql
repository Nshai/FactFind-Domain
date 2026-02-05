SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningSession]
	@StampUser varchar (255),
	@FinancialPlanningSessionId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningSessionAudit 
( FinancialPlanningId, FactFindId, CRMContactId, Description, 
		Date, RefFinancialPlanningSessionStatusId, UserId, OpportunityId, 
		DocumentId, ConcurrencyId, SessionId, IsCompleted, CRMContactId2, ServiceCaseId, FeeModelId, InitialFeePercentage, OngoingFeePercentage,
	RequestFailed, FinancialPlanningSessionId, StampAction, StampDateTime, StampUser) 
Select FinancialPlanningId, FactFindId, CRMContactId, Description, 
		Date, RefFinancialPlanningSessionStatusId, UserId, OpportunityId, 
		DocumentId, ConcurrencyId, SessionId, IsCompleted, CRMContactId2, ServiceCaseId, FeeModelId, InitialFeePercentage, OngoingFeePercentage,
		RequestFailed, FinancialPlanningSessionId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningSession
WHERE FinancialPlanningSessionId = @FinancialPlanningSessionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)



GO
