SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPasswordPolicy]
	@StampUser varchar (255),
	@PasswordPolicyId bigint,
	@StampAction char(1)
AS

INSERT INTO TPasswordPolicyAudit 
( Expires, ExpiryDays, UniquePasswords, MaxFailedLogins, 
		AllowExpireAllPasswords, AllowAutoUserNameGeneration, 
		IndigoClientId, ConcurrencyId, LockoutPeriodMinutes, NumberOfMonthsBeforePasswordReuse, 
	PasswordPolicyId, StampAction, StampDateTime, StampUser) 
Select Expires, ExpiryDays, UniquePasswords, MaxFailedLogins, 
		AllowExpireAllPasswords, AllowAutoUserNameGeneration, 
		IndigoClientId, ConcurrencyId, LockoutPeriodMinutes, NumberOfMonthsBeforePasswordReuse, 
	PasswordPolicyId, @StampAction, GetDate(), @StampUser
FROM TPasswordPolicy
WHERE PasswordPolicyId = @PasswordPolicyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
