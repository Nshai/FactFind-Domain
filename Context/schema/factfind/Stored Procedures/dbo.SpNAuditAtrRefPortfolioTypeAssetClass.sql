SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrRefPortfolioTypeAssetClass]
	@StampUser varchar (255),
	@AtrRefPortfolioTypeAssetClassId bigint,
	@StampAction char(1)
AS

INSERT INTO TAtrRefPortfolioTypeAssetClassAudit 
( AtrRefPortfolioTypeId, AtrRefAssetClassId, ConcurrencyId, 
	AtrRefPortfolioTypeAssetClassId, StampAction, StampDateTime, StampUser) 
Select AtrRefPortfolioTypeId, AtrRefAssetClassId, ConcurrencyId, 
	AtrRefPortfolioTypeAssetClassId, @StampAction, GetDate(), @StampUser
FROM TAtrRefPortfolioTypeAssetClass
WHERE AtrRefPortfolioTypeAssetClassId = @AtrRefPortfolioTypeAssetClassId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
