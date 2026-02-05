SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

create PROCEDURE [dbo].[SpNAuditAtrTemplateToeValueTemplateByMaxId]
	@StampUser varchar (255),
	@MaxId bigint,
	@StampAction char(1)
AS


INSERT INTO TAtrTemplateToeValueTemplateAudit 
( [AtrTemplateToeValueTemplateId],[AtrTemplateGuid],[RefEValueAtrTemplateId],[ConcurrencyId],
			[StampAction],[StampDateTime],[StampUser]) 
Select [AtrTemplateToeValueTemplateId],[AtrTemplateGuid],[RefEValueAtrTemplateId],[ConcurrencyId], @StampAction, GetDate(), @StampUser
FROM TAtrTemplateToeValueTemplate
WHERE [AtrTemplateToeValueTemplateId] > @MaxId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
