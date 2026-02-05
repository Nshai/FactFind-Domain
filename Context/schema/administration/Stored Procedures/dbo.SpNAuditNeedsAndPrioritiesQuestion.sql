SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditNeedsAndPrioritiesQuestion]
	@StampUser varchar (255),
	@NeedsAndPrioritiesQuestionId bigint,
	@StampAction char(1)
AS

INSERT INTO [TNeedsAndPrioritiesQuestionAudit] (
	Question, Ordinal, IsArchived, ConcurrencyId, NeedsAndPrioritiesQuestionId, 
	RefPersonalCategoryId, RefCorporateCategoryId, IsForProfile, IsTextArea, NeedsAndPrioritiesSubCategoryId,
	ControlTypeId, PlaceHolderText, HelpText, ErrorText, Pattern, IsRequired, StampAction, StampDateTime, StampUser)
SELECT
	Question, Ordinal, IsArchived, ConcurrencyId, NeedsAndPrioritiesQuestionId, 
	RefPersonalCategoryId, RefCorporateCategoryId, IsForProfile, IsTextArea, NeedsAndPrioritiesSubCategoryId,
	ControlTypeId, PlaceHolderText, HelpText, ErrorText, Pattern, IsRequired, @StampAction, GETDATE(), @StampUser
FROM 
	[Administration].[dbo].[TNeedsAndPrioritiesQuestion]
WHERE 
	NeedsAndPrioritiesQuestionId = @NeedsAndPrioritiesQuestionId

IF @@ERROR != 0 GOTO errh
RETURN (0)

errh:
RETURN (100)
GO