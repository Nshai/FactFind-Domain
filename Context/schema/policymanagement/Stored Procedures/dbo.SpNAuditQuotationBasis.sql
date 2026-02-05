SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditQuotationBasis]
	@StampUser varchar (255),
	@QuotationBasisId bigint,
	@StampAction char(1)
AS

INSERT INTO TQuotationBasisAudit 
( QuotationBasisType, MinValue, MaxValue, RateOfIncrease, 
		TenantId, ConcurrencyId, 
	QuotationBasisId, StampAction, StampDateTime, StampUser) 
Select QuotationBasisType, MinValue, MaxValue, RateOfIncrease, 
		TenantId, ConcurrencyId, 
	QuotationBasisId, @StampAction, GetDate(), @StampUser
FROM TQuotationBasis
WHERE QuotationBasisId = @QuotationBasisId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
