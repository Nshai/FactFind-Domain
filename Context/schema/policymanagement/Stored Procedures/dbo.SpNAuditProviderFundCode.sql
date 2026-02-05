SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditProviderFundCode]
	@StampUser varchar (255),
	@ProviderFundCodeId bigint,
	@StampAction char(1)
AS

INSERT INTO TProviderFundCodeAudit 
( RefProdProviderId, ProviderFundCode, FundId, FundTypeId, 
		ConcurrencyId, 
	ProviderFundCodeId, StampAction, StampDateTime, StampUser) 
Select RefProdProviderId, ProviderFundCode, FundId, FundTypeId, 
		ConcurrencyId, 
	ProviderFundCodeId, @StampAction, GetDate(), @StampUser
FROM TProviderFundCode
WHERE ProviderFundCodeId = @ProviderFundCodeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
