SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrRefPortfolioType]
	@StampUser varchar (255),
	@AtrRefPortfolioTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TAtrRefPortfolioTypeAudit 
( Identifier, Custom, ConcurrencyId, 
	AtrRefPortfolioTypeId, StampAction, StampDateTime, StampUser) 
Select Identifier, Custom, ConcurrencyId, 
	AtrRefPortfolioTypeId, @StampAction, GetDate(), @StampUser
FROM TAtrRefPortfolioType
WHERE AtrRefPortfolioTypeId = @AtrRefPortfolioTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
