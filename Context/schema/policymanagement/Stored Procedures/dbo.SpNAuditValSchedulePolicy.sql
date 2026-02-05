SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditValSchedulePolicy]
	@StampUser varchar (255),
	@ValSchedulePolicyId bigint,
	@StampAction char(1)
AS

INSERT INTO TValSchedulePolicyAudit 
( ValScheduleId, PolicyBusinessId, ClientCRMContactId, UserCredentialOption, 
		PortalCRMContactId, ConcurrencyId, 
	ValSchedulePolicyId, StampAction, StampDateTime, StampUser) 
Select ValScheduleId, PolicyBusinessId, ClientCRMContactId, UserCredentialOption, 
		PortalCRMContactId, ConcurrencyId, 
	ValSchedulePolicyId, @StampAction, GetDate(), @StampUser
FROM TValSchedulePolicy
WHERE ValSchedulePolicyId = @ValSchedulePolicyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
