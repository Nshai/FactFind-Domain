SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditApplicationAccount]
	@StampUser varchar (255),
	@ApplicationAccountId bigint,
	@StampAction char(1)
AS

INSERT INTO TApplicationAccountAudit 
( RefApplicationId, UserId, UserName, AdditionalReference, Password, Password2, 
		ConcurrencyId, 
	ApplicationAccountId, StampAction, StampDateTime, StampUser,GroupName, Token, TokenExpiryDate) 
Select RefApplicationId, UserId, UserName, AdditionalReference, Password, Password2,
		ConcurrencyId, 
	ApplicationAccountId, @StampAction, GetDate(), @StampUser,GroupName, Token, TokenExpiryDate
FROM TApplicationAccount
WHERE ApplicationAccountId = @ApplicationAccountId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
