SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefNationality]
	@StampUser varchar (255),
	@RefNationalityId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefNationalityAudit 
( RefNationalityId, ConcurrencyId, 
	Name,IsArchived,StampAction, StampDateTime, StampUser) 
Select RefNationalityId, ConcurrencyId, 
	Name,IsArchived,@StampAction, GetDate(), @StampUser
FROM TRefNationality
WHERE RefNationalityId = @RefNationalityId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO