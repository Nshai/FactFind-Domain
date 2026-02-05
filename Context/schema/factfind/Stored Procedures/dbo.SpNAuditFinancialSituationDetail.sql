SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFinancialSituationDetail]
	@StampUser varchar (255),
	@FinancialSituationDetailId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialSituationDetailAudit 
( CRMContactId, Year, Turnover, GrossProfit, 
		NetProfitBeforeTax, TaxBill, PAT, ConcurrencyId, 
		
	FinancialSituationDetailId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Year, Turnover, GrossProfit, 
		NetProfitBeforeTax, TaxBill, PAT, ConcurrencyId, 
		
	FinancialSituationDetailId, @StampAction, GetDate(), @StampUser
FROM TFinancialSituationDetail
WHERE FinancialSituationDetailId = @FinancialSituationDetailId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
