SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFinancialSituation]
	@StampUser varchar (255),
	@FinancialSituationId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialSituationAudit 
( CRMContactId, DateEstablished, FinancialYearEnd, ApproxValue, 
		TotalInvestmentAssetValue, TotalCollateralValue, ValueIncreasingYesNo, Rate, ConcurrencyId, 
	FinancialSituationId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, DateEstablished, FinancialYearEnd, ApproxValue, 
		TotalInvestmentAssetValue, TotalCollateralValue, ValueIncreasingYesNo, Rate, ConcurrencyId, 
	FinancialSituationId, @StampAction, GetDate(), @StampUser
FROM TFinancialSituation
WHERE FinancialSituationId = @FinancialSituationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
