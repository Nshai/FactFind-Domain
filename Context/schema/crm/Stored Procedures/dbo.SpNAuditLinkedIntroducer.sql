SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditLinkedIntroducer]
	@StampUser varchar (255),
	@LinkedIntroducerId bigint,
	@StampAction char(1)
AS

INSERT INTO TLinkedIntroducerAudit 
( LinkedIntroducerId, CorporateIntroducerId, PersonIntroducerId, ConcurrencyId, 
  StampAction, StampDateTime, StampUser) 
SELECT LinkedIntroducerId, CorporateIntroducerId, PersonIntroducerId, ConcurrencyId, 
	@StampAction, GetDate(), @StampUser
FROM TLinkedIntroducer
WHERE LinkedIntroducerId = @LinkedIntroducerId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
