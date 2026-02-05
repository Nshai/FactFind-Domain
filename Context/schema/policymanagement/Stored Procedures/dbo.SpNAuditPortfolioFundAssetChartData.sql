SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPortfolioFundAssetChartData]
	@StampUser varchar (255),
	@PortfolioFundAssetChartDataId bigint,
	@StampAction char(1)
AS

INSERT INTO TPortfolioFundAssetChartDataAudit 
( PortfolioId, AssetXMLData, ConcurrencyId, 
	PortfolioFundAssetChartDataId, StampAction, StampDateTime, StampUser) 
Select PortfolioId, AssetXMLData, ConcurrencyId, 
	PortfolioFundAssetChartDataId, @StampAction, GetDate(), @StampUser
FROM TPortfolioFundAssetChartData
WHERE PortfolioFundAssetChartDataId = @PortfolioFundAssetChartDataId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
