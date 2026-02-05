SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditPlanExceptionDetails]
	@StampUser varchar (255),
	@PlanExceptionDetailsId bigint,
	@StampAction char(1)
AS

INSERT INTO TPlanExceptionDetailsAudit 
( PlanExceptionQueueId, IsExceeedingSumAssured, IsExceedingLumpSum, IsExceeedingRegularContribution, 
		IsViolatingAgeLimit, TenantId, ConcurrencyId, 
	PlanExceptionDetailsId, StampAction, StampDateTime, StampUser, IsPOA,HasMatchingATR,HasMatchingAdviceCaseStatus,HasMatchingVulnerableCustomer) 
Select PlanExceptionQueueId, IsExceeedingSumAssured, IsExceedingLumpSum, IsExceeedingRegularContribution, 
		IsViolatingAgeLimit, TenantId, ConcurrencyId, 
	PlanExceptionDetailsId, @StampAction, GetDate(), @StampUser, IsPOA,HasMatchingATR,HasMatchingAdviceCaseStatus,HasMatchingVulnerableCustomer
FROM TPlanExceptionDetails
WHERE PlanExceptionDetailsId = @PlanExceptionDetailsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
