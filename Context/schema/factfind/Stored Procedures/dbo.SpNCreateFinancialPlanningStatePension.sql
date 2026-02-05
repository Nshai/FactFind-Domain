SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateFinancialPlanningStatePension]
	@StampUser varchar (255),
	@CRMContactId bigint, 
	@RefPensionForecastId int = 1, 
	@BasicAnnualAmount money = 0, 
	@AdditionalAnnualAmount money = 0,
	@TaxYearStartWork int = 0,
	@TaxYearFinishWork int = 0,
	@AnnualSalary money = 0
	
AS


DECLARE @FinancialPlanningStatePensionId bigint, @Result int
			
	
INSERT INTO TFinancialPlanningStatePension
(CRMContactId, RefPensionForecastId, BasicAnnualAmount, AdditionalAnnualAmount,TaxYearStartWork, TaxYearFinishWork,AnnualSalary, ConcurrencyId)
VALUES(@CRMContactId, @RefPensionForecastId, @BasicAnnualAmount, @AdditionalAnnualAmount,@TaxYearStartWork, @TaxYearFinishWork,@AnnualSalary, 1)

SELECT @FinancialPlanningStatePensionId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditFinancialPlanningStatePension @StampUser, @FinancialPlanningStatePensionId, 'C'

IF @Result  != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
