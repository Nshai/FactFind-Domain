SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SpNAuditAdvisaCentaErrorLog]
	@StampUser varchar (255),
	@AdvisaCentaErrorLogId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdvisaCentaErrorLogAudit 
(FinancialPlanningSessionId, IoMessage, Exception,	CreatedDate, UserId,	TenantId,
  ConcurrencyId, AdvisaCentaErrorLogId,	StampAction, StampDateTime, StampUser) 

Select FinancialPlanningSessionId, IoMessage, Exception,CreatedDate,	UserId, TenantId,
  ConcurrencyId, AdvisaCentaErrorLogId, @StampAction, GetDate(), @StampUser
FROM TAdvisaCentaErrorLog
WHERE AdvisaCentaErrorLogId = @AdvisaCentaErrorLogId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
