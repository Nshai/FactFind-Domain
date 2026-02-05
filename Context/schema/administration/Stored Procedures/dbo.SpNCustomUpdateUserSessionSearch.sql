SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateUserSessionSearch]
	@UserSessionId Bigint,
	@ConcurrencyId bigint,
	@StampUser varchar (255),
	@Search text = NULL

AS



Declare @Result int
Execute @Result = dbo.SpNAuditUserSession @StampUser, @UserSessionId, 'U'

IF @Result  != 0 GOTO errh

UPDATE T1
SET T1.Search = @Search, T1.ConcurrencyId = T1.ConcurrencyId + 1
FROM TUserSession T1
WHERE  T1.UserSessionId = @UserSessionId --And T1.ConcurrencyId = @ConcurrencyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
