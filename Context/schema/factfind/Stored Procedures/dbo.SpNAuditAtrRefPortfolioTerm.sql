SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrRefPortfolioTerm]
	@StampUser varchar (255),
	@AtrRefPortfolioTermId bigint,
	@StampAction char(1)
AS

INSERT INTO TAtrRefPortfolioTermAudit 
( Term, Identifier, ConcurrencyId, 
	AtrRefPortfolioTermId, StampAction, StampDateTime, StampUser) 
Select Term, Identifier, ConcurrencyId, 
	AtrRefPortfolioTermId, @StampAction, GetDate(), @StampUser
FROM TAtrRefPortfolioTerm
WHERE AtrRefPortfolioTermId = @AtrRefPortfolioTermId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
