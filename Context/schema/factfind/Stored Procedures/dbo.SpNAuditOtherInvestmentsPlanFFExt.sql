SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditOtherInvestmentsPlanFFExt]
	@StampUser varchar (255),
	@OtherInvestmentsPlanFFExtId bigint,
	@StampAction char(1)
AS

INSERT INTO TOtherInvestmentsPlanFFExtAudit 
( PolicyBusinessId, ContributionThisTaxYearFg, MonthlyIncome, InTrustFg, 
		ConcurrencyId, 
	OtherInvestmentsPlanFFExtId, StampAction, StampDateTime, StampUser) 
Select PolicyBusinessId, ContributionThisTaxYearFg, MonthlyIncome, InTrustFg, 
		ConcurrencyId, 
	OtherInvestmentsPlanFFExtId, @StampAction, GetDate(), @StampUser
FROM TOtherInvestmentsPlanFFExt
WHERE OtherInvestmentsPlanFFExtId = @OtherInvestmentsPlanFFExtId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
