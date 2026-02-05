SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditIVA]
	@StampUser varchar (255),
	@IVAId bigint,
	@StampAction char(1)
AS

INSERT INTO TIVAAudit 
( CRMContactId, ivaCurrentFg, ivaNoYears, ivaDate, 
		ivaApp1, ivaApp2, ConcurrencyId, 
	IVAId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, ivaCurrentFg, ivaNoYears, ivaDate, 
		ivaApp1, ivaApp2, ConcurrencyId, 
	IVAId, @StampAction, GetDate(), @StampUser
FROM TIVA
WHERE IVAId = @IVAId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
