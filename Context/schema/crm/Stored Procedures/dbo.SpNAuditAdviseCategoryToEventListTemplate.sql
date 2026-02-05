SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditAdviseCategoryToEventListTemplate]
	@StampUser varchar (255),
	@AdviseCategoryToEventListTemplateId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdviseCategoryToEventListTemplateAudit 
( AdviseCategoryId, EventListTemplateId, ConcurrencyId, 
	AdviseCategoryToEventListTemplateId, StampAction, StampDateTime, StampUser) 
Select AdviseCategoryId, EventListTemplateId, ConcurrencyId, 
	AdviseCategoryToEventListTemplateId, @StampAction, GetDate(), @StampUser
FROM TAdviseCategoryToEventListTemplate
WHERE AdviseCategoryToEventListTemplateId = @AdviseCategoryToEventListTemplateId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
