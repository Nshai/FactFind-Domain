SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditIntroducerExtended]
	@StampUser varchar (255),
	@IntroducerExtendedId bigint,
	@StampAction char(1)
AS

INSERT INTO TIntroducerExtendedAudit 
( IntroducerId, MigrationRef, ConcurrencyId, 
	IntroducerExtendedId, StampAction, StampDateTime, StampUser) 
Select IntroducerId, MigrationRef, ConcurrencyId, 
	IntroducerExtendedId, @StampAction, GetDate(), @StampUser
FROM TIntroducerExtended
WHERE IntroducerExtendedId = @IntroducerExtendedId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
