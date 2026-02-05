SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCorporateAdviceAreas]
	@StampUser varchar (255),
	@CorporateAdviceAreasId bigint,
	@StampAction char(1)
AS

INSERT INTO TCorporateAdviceAreasAudit 
( CRMContactId, advicetype, PA, RPA, 
		SIA, DateOfFirstAppointment, ConcurrencyId, 
	CorporateAdviceAreasId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, advicetype, PA, RPA, 
		SIA, DateOfFirstAppointment, ConcurrencyId, 
	CorporateAdviceAreasId, @StampAction, GetDate(), @StampUser
FROM TCorporateAdviceAreas
WHERE CorporateAdviceAreasId = @CorporateAdviceAreasId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
