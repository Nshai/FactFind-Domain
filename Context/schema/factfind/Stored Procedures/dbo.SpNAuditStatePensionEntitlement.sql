SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditStatePensionEntitlement]
	@StampUser varchar (255),
	@StatePensionEntitlementId bigint,
	@StampAction char(1)
AS

INSERT INTO TStatePensionEntitlementAudit (
	StatePensionEntitlementId, CRMContactId, StatePensionRetirementAge, BasicStatePension, AdditionalStatePension, 
	PensionCredit, SpousesPension, BR19Projection, Notes, ConcurrencyId, StampAction, StampDateTime, StampUser)
SELECT 
	StatePensionEntitlementId, CRMContactId, StatePensionRetirementAge, BasicStatePension, AdditionalStatePension, 
	PensionCredit, SpousesPension, BR19Projection, Notes, ConcurrencyId, @StampAction, GETDATE(), @StampUser
FROM 
	TStatePensionEntitlement
WHERE 
	StatePensionEntitlementId = @StatePensionEntitlementId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
