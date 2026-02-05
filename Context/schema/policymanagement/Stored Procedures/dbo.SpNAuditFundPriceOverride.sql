SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFundPriceOverride]
	@StampUser varchar (255),
	@FundPriceOverrideId bigint,
	@StampAction char(1)
AS

INSERT INTO TFundPriceOverrideAudit 
( IndigoClientId, FundId, FundTypeId, FromFeedFg, 
		PriceDate, Price, PriceUpdatedBy, ConcurrencyId, 
		
	FundPriceOverrideId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, FundId, FundTypeId, FromFeedFg, 
		PriceDate, Price, PriceUpdatedBy, ConcurrencyId, 
		
	FundPriceOverrideId, @StampAction, GetDate(), @StampUser
FROM TFundPriceOverride
WHERE FundPriceOverrideId = @FundPriceOverrideId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
