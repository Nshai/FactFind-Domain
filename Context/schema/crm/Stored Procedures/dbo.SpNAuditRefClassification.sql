SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefClassification]
	@StampUser varchar (255),
	@RefClassificationId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefClassificationAudit 
( Name, Description, Colour, IsArchived, 
		UserId, ConcurrencyId, 
	RefClassificationId, StampAction, StampDateTime, StampUser) 
Select Name, Description, Colour, IsArchived, 
		UserId, ConcurrencyId, 
	RefClassificationId, @StampAction, GetDate(), @StampUser
FROM TRefClassification
WHERE RefClassificationId = @RefClassificationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
