SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefAdditionalPropertyDetail]
	@StampUser varchar (255),
	@RefAdditionalPropertyDetailId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefAdditionalPropertyDetailAudit 
( [Description], ConcurrencyId, 
	RefAdditionalPropertyDetailId, StampAction, StampDateTime, StampUser) 
Select [Description], ConcurrencyId, 
	RefAdditionalPropertyDetailId, @StampAction, GetDate(), @StampUser
FROM TRefAdditionalPropertyDetail
WHERE RefAdditionalPropertyDetailId = @RefAdditionalPropertyDetailId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
