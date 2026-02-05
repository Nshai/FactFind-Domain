SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditValUserSetup]
	@StampUser varchar (255),
	@ValUserSetupId bigint,
	@StampAction char(1)
AS

INSERT INTO TValUserSetupAudit 
( UserId, UseValuationFundsFg, UseValuationAssetsFg, ConcurrencyId, 
		
	ValUserSetupId, StampAction, StampDateTime, StampUser) 
Select UserId, UseValuationFundsFg, UseValuationAssetsFg, ConcurrencyId, 
		
	ValUserSetupId, @StampAction, GetDate(), @StampUser
FROM TValUserSetup
WHERE ValUserSetupId = @ValUserSetupId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
