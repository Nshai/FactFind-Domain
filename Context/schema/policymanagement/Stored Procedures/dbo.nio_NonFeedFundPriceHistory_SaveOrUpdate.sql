SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_NonFeedFundPriceHistory_SaveOrUpdate]
	@NonFeedFundId int,
	@PriceDate date,
	@Price float
AS

IF EXISTS (SELECT 1 FROM TNonFeedFundPriceHistory WHERE NonFeedFundId = @NonFeedFundId AND PriceDate = @PriceDate)
	UPDATE TNonFeedFundPriceHistory 
	SET Price = @Price
	WHERE 
		NonFeedFundId = @NonFeedFundId 
		AND PriceDate = @PriceDate
ELSE
	INSERT INTO TNonFeedFundPriceHistory (NonFeedFundId, PriceDate, Price)
	VALUES (@NonFeedFundId, @PriceDate, @Price)

GO
