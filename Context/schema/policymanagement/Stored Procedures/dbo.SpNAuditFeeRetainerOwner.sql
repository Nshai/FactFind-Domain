SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFeeRetainerOwner]
	@StampUser varchar (255),
	@FeeRetainerOwnerId bigint,
	@StampAction char(1)
AS

INSERT INTO TFeeRetainerOwnerAudit 
( FeeId, RetainerId, CRMContactId, TnCCoachId, 
		PractitionerId, BandingTemplateId, IndigoClientId, ConcurrencyId, SecondaryOwnerId,
		
	FeeRetainerOwnerId, StampAction, StampDateTime, StampUser) 
Select FeeId, RetainerId, CRMContactId, TnCCoachId, 
		PractitionerId, BandingTemplateId, IndigoClientId, ConcurrencyId, SecondaryOwnerId,
		
	FeeRetainerOwnerId, @StampAction, GetDate(), @StampUser
FROM TFeeRetainerOwner
WHERE FeeRetainerOwnerId = @FeeRetainerOwnerId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
