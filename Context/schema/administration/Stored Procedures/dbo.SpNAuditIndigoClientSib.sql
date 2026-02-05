SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditIndigoClientSib]
	@StampUser varchar (255),
	@IndigoClientSibId bigint,
	@StampAction char(1)
AS

INSERT INTO TIndigoClientSibAudit 
( IndigoClientId, GroupId, Sib, IsAgencyCode, 
		Guid, ConcurrencyId, 
	IndigoClientSibId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, GroupId, Sib, IsAgencyCode, 
		Guid, ConcurrencyId, 
	IndigoClientSibId, @StampAction, GetDate(), @StampUser
FROM TIndigoClientSib
WHERE IndigoClientSibId = @IndigoClientSibId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
