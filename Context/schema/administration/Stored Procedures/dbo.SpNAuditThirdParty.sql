SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditThirdParty]
	@StampUser varchar (255),
	@ThirdPartyId bigint,
	@StampAction char(1)
AS

INSERT INTO TThirdPartyAudit 
( ThirdPartyDescription, ConcurrencyId, 
	ThirdPartyId, StampAction, StampDateTime, StampUser) 
Select ThirdPartyDescription, ConcurrencyId, 
	ThirdPartyId, @StampAction, GetDate(), @StampUser
FROM TThirdParty
WHERE ThirdPartyId = @ThirdPartyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
