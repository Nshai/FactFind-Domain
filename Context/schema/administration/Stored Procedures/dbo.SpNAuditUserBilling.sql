SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditUserBilling]
	@StampUser varchar (255),
	@UserBillingId bigint,
	@StampAction char(1)
AS

INSERT INTO TUserBillingAudit 
( UserId, HourlyBillingRate, ConcurrencyId, 
	UserBillingId, StampAction, StampDateTime, StampUser) 
Select UserId, HourlyBillingRate, ConcurrencyId, 
	UserBillingId, @StampAction, GetDate(), @StampUser
FROM TUserBilling
WHERE UserBillingId = @UserBillingId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
