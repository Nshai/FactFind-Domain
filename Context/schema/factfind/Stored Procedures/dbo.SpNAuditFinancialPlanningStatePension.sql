SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningStatePension]
	@StampUser varchar (255),
	@FinancialPlanningStatePensionId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningStatePensionAudit 
(CRMContactId, RefPensionForecastId, BasicAnnualAmount, AdditionalAnnualAmount,TaxYearStartWork, TaxYearFinishWork, AnnualSalary, ConcurrencyId,
	FinancialPlanningStatePensionId, StampAction, StampDateTime, StampUser)
SELECT  CRMContactId, RefPensionForecastId, BasicAnnualAmount, AdditionalAnnualAmount,TaxYearStartWork, TaxYearFinishWork, AnnualSalary, ConcurrencyId,
	FinancialPlanningStatePensionId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningStatePension
WHERE FinancialPlanningStatePensionId = @FinancialPlanningStatePensionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
