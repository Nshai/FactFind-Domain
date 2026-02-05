SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditRefEValueAtrTemplate]
	@StampUser varchar (255),
	@RefEValueAtrTemplateId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefEValueAtrTemplateAudit 
( [Identifier],[ConcurrencyId],[RefEValueAtrTemplateId],
			[StampAction],[StampDateTime],[StampUser]) 
Select [Identifier],[ConcurrencyId],[RefEValueAtrTemplateId], @StampAction, GetDate(), @StampUser
FROM TRefEValueAtrTemplate
WHERE RefEValueAtrTemplateId > @RefEValueAtrTemplateId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
