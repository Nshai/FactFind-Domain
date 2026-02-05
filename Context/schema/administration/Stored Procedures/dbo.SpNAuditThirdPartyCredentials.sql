SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditThirdPartyCredentials]
	@StampUser varchar (255),
	@ThirdPartyCredentialsId bigint,
	@StampAction char(1)
AS

INSERT INTO TThirdPartyCredentialsAudit 
( UserId, ThirdPartyId, UserDescription, UserName, 
		Password, Password2, ConcurrencyId, 
	ThirdPartyCredentialsId, StampAction, StampDateTime, StampUser) 
Select UserId, ThirdPartyId, UserDescription, UserName, 
		Password, Password2, ConcurrencyId, 
	ThirdPartyCredentialsId, @StampAction, GetDate(), @StampUser
FROM TThirdPartyCredentials
WHERE ThirdPartyCredentialsId = @ThirdPartyCredentialsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
