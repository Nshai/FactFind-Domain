SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpNAuditIntroducer
	@StampUser varchar (255),
	@IntroducerId bigint,
	@StampAction char(1)
AS

INSERT INTO TIntroducerAudit 
	(IndClientId,
	CRMContactId,
	AgreementDate,
	RefIntroducerTypeId,
	PractitionerId,
	ArchiveFG,
	Identifier,
	[UniqueIdentifier],
	ConcurrencyId,
	IntroducerId,
	StampAction,
	StampDateTime,
	StampUser)
SELECT  
	IndClientId,
	CRMContactId,
	AgreementDate,
	RefIntroducerTypeId,
	PractitionerId,
	ArchiveFG,
	Identifier,
	[UniqueIdentifier],
	ConcurrencyId,
	IntroducerId, 
	@StampAction, 
	GetDate(), 
	@StampUser
FROM TIntroducer
WHERE IntroducerId = @IntroducerId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
