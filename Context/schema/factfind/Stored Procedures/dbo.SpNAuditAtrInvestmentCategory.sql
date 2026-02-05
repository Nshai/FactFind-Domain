SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAtrInvestmentCategory]
	@StampUser varchar (255),
	@AtrInvestmentCategoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TAtrInvestmentCategoryAudit 
(CRMContactId, AtrCategoryId, ConcurrencyId,
	AtrInvestmentCategoryId, StampAction, StampDateTime, StampUser)
SELECT  CRMContactId, AtrCategoryId, ConcurrencyId,
	AtrInvestmentCategoryId, @StampAction, GetDate(), @StampUser
FROM TAtrInvestmentCategory
WHERE AtrInvestmentCategoryId = @AtrInvestmentCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
