SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditQuoteBond]
	@StampUser varchar (255),
	@QuoteBondId bigint,
	@StampAction char(1)
AS

INSERT INTO TQuoteBondAudit 
( QuoteItemId, InvestmentAmount, Term, FinalCIV, 
		NumFreeSwitches, MedGrowthRate, ConcurrencyId, 
	QuoteBondId, StampAction, StampDateTime, StampUser) 
Select QuoteItemId, InvestmentAmount, Term, FinalCIV, 
		NumFreeSwitches, MedGrowthRate, ConcurrencyId, 
	QuoteBondId, @StampAction, GetDate(), @StampUser
FROM TQuoteBond
WHERE QuoteBondId = @QuoteBondId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
