SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefNeedsAndPrioritiesCategory]
	@StampUser varchar (255),
	@RefNeedsAndPrioritiesCategoryId int,
	@StampAction char(1)
AS

INSERT INTO TRefNeedsAndPrioritiesCategoryAudit (
	RefNeedsAndPrioritiesCategoryId, ConcurrencyId, CategoryName, Ordinal, IsCorporate, CategoryType, StampAction, StampDateTime, StampUser)
SELECT 
	RefNeedsAndPrioritiesCategoryId, ConcurrencyId, CategoryName, Ordinal, IsCorporate, CategoryType, @StampAction, GETDATE(), @StampUser
FROM 
	TRefNeedsAndPrioritiesCategory
WHERE 
	RefNeedsAndPrioritiesCategoryId = @RefNeedsAndPrioritiesCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
