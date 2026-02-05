SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--select dbo.FnCustomGetConvertedFundPrice(4861)
CREATE FUNCTION  [dbo].[FnCustomGetConvertedFundPrice](@FundUnitId bigint)
RETURNS money
AS
BEGIN

DECLARE @PriceInPounds money

	SELECT @PriceInPounds =
		case     
			when fu.Currency = 'GBX' then     
				case when isnull(fup.MidPrice,0) > 0 then    
					fup.MidPrice/100    
				else    
					fup.BidPrice/100    
				end    
			else     
				case when isnull(fup.MidPrice,0) > 0 then    
					fup.MidPrice / isnull(cr.rate,1)    
				else    
					fup.BidPrice / isnull(cr.rate,1)    
				end    
			       
		 end
		FROM Fund2..TFundUnit fu
		LEFT JOIN Fund2..TFundUnitPrice fup ON fup.FundUnitId = fu.FundUnitId
		LEFT JOIN Administration..TCurrencyRate cr ON cr.CurrencyCode = fu.Currency AND cr.IndigoClientId = 0
		WHERE fu.FundUnitId = @FundUnitId


RETURN @PriceInPounds

END
GO
