SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateQuotePension]
	@StampUser varchar (255),
	@QuoteItemId bigint, 
	@Contribution decimal (18,0)  = NULL, 
	@EmployerContribution decimal (18,0)  = NULL, 
	@RetirementAge int = NULL, 
	@TotalFundValue decimal (18,0)  = NULL, 
	@Pension decimal (18,0)  = NULL, 
	@CashSum decimal (18,0)  = NULL, 
	@ReducedPension decimal (18,0)  = NULL, 
	@MediumGrowthRate decimal (18,0)  = NULL	
AS


DECLARE @QuotePensionId bigint, @Result int
			
	
INSERT INTO TQuotePension
(QuoteItemId, Contribution, EmployerContribution, RetirementAge, TotalFundValue, Pension, 
	CashSum, ReducedPension, MediumGrowthRate, ConcurrencyId)
VALUES(@QuoteItemId, @Contribution, @EmployerContribution, @RetirementAge, @TotalFundValue, @Pension, 
	@CashSum, @ReducedPension, @MediumGrowthRate, 1)

SELECT @QuotePensionId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh

Execute @Result = dbo.SpNAuditQuotePension @StampUser, @QuotePensionId, 'C'

IF @Result  != 0 GOTO errh

Execute dbo.SpNRetrieveQuotePensionByQuotePensionId @QuotePensionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
