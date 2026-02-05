SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateContactDefaultFg]
@ContactId bigint,
@StampUser varchar (255),
@IndClientId bigint,
@CRMContactId bigint,
@RefContactType varchar (50)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	INSERT INTO Crm..TContactAudit 
	(IndClientId, CRMContactId, RefContactType, Description, Value, DefaultFg, ConcurrencyId, 
	ContactId, StampAction, StampDateTime, StampUser)
	SELECT T1.IndClientId, T1.CRMContactId, T1.RefContactType, T1.Description, T1.Value, T1.DefaultFg, T1.ConcurrencyId,
	T1.ContactId, 'U', GetDate(), @StampUser
	FROM Crm..TContact T1
	WHERE IndClientId = @IndClientId And CRMContactId = @CRMContactId And RefContactType = @RefContactType And T1.ContactId <> @ContactId

	UPDATE T1
	SET T1.DefaultFg = 0, T1.ConcurrencyId = T1.ConcurrencyId + 1
	FROM Crm..TContact T1
	WHERE IndClientId = @IndClientId And CRMContactId = @CRMContactId And RefContactType = @RefContactType And T1.ContactId <> @ContactId


IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
