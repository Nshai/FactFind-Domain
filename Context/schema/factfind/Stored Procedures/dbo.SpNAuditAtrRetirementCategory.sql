SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAtrRetirementCategory]
	@StampUser varchar (255),
	@AtrRetirementCategoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TAtrRetirementCategoryAudit 
(CRMContactId, AtrCategoryId, ConcurrencyId,
	AtrRetirementCategoryId, StampAction, StampDateTime, StampUser)
SELECT  CRMContactId, AtrCategoryId, ConcurrencyId,
	AtrRetirementCategoryId, @StampAction, GetDate(), @StampUser
FROM TAtrRetirementCategory
WHERE AtrRetirementCategoryId = @AtrRetirementCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
