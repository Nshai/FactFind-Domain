SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditProtectionMiscellaneous]
	@StampUser varchar (255),
	@ProtectionMiscellaneousId bigint,
	@StampAction char(1)
AS

INSERT INTO TProtectionMiscellaneousAudit 
(ConcurrencyId, CRMContactId, HasExistingProvision, NonDisclosure, Notes, IncomeReplacementRate,
	ProtectionMiscellaneousId, StampAction, StampDateTime, StampUser)
SELECT  ConcurrencyId, CRMContactId, HasExistingProvision, NonDisclosure, Notes, IncomeReplacementRate,
	ProtectionMiscellaneousId, @StampAction, GetDate(), @StampUser
FROM TProtectionMiscellaneous
WHERE ProtectionMiscellaneousId = @ProtectionMiscellaneousId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
