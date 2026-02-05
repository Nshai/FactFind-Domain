SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditStatus]
	@StampUser varchar (255),
	@StatusId bigint,
	@StampAction char(1)
AS

INSERT INTO TStatusAudit 
( Name, OrigoStatusId, IntelligentOfficeStatusType, PreComplianceCheck, 
		PostComplianceCheck, SystemSubmitFg, IndigoClientId, ConcurrencyId, 
		
	StatusId, StampAction, StampDateTime, StampUser, IsPipelineStatus) 
Select Name, OrigoStatusId, IntelligentOfficeStatusType, PreComplianceCheck, 
		PostComplianceCheck, SystemSubmitFg, IndigoClientId, ConcurrencyId, 
		
	StatusId, @StampAction, GetDate(), @StampUser, IsPipelineStatus
FROM TStatus
WHERE StatusId = @StatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
