SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefEmailDuplicateConfig]
	@StampUser varchar (255),
	@RefEmailDuplicateConfigId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefEmailDuplicateConfigAudit 
( DuplicateConfigName, ConcurrencyId, 
	RefEmailDuplicateConfigId, StampAction, StampDateTime, StampUser) 
Select DuplicateConfigName, ConcurrencyId, 
	RefEmailDuplicateConfigId, @StampAction, GetDate(), @StampUser
FROM TRefEmailDuplicateConfig
WHERE RefEmailDuplicateConfigId = @RefEmailDuplicateConfigId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
