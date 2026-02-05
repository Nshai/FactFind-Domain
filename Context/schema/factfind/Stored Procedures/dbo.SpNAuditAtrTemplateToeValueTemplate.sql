SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditAtrTemplateToeValueTemplate]
	@StampUser varchar (255),
	@AtrTemplateToeValueTemplateId bigint,
	@StampAction char(1)
AS

INSERT INTO TAtrTemplateToeValueTemplateAudit 
( [AtrTemplateToeValueTemplateId],[AtrTemplateGuid],[RefEValueAtrTemplateId],[ConcurrencyId],
			[StampAction],[StampDateTime],[StampUser]) 
Select [AtrTemplateToeValueTemplateId],[AtrTemplateGuid],[RefEValueAtrTemplateId],[ConcurrencyId], @StampAction, GetDate(), @StampUser
FROM TAtrTemplateToeValueTemplate
WHERE [AtrTemplateToeValueTemplateId] > @AtrTemplateToeValueTemplateId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
