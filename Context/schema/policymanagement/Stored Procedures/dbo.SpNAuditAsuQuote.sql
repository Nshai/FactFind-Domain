SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAsuQuote]
	@StampUser varchar (255),
	@QuoteId bigint,
	@StampAction char(1)
AS

INSERT INTO TAsuQuoteAudit 
	(
	UnemploymentWait,
	DisabilityWait,
	UnemploymentWaitType,
	DisabilityWaitType,
	CoverType,
	PolicyBenefitPeriod,
	BenefitUplift,
	DeferrePremiumLength,
	TotalBenefit,
	MonthlyMortgagePayment,
	OtherCover,
	Customer1Benefit,
	BenefitUpliftAmount,
	ProductToQuote,
	ConcurrencyId,
	QuoteId,
	StampAction,
	StampDateTime,
	StampUser
	
	) 
SELECT 	
	UnemploymentWait,
	DisabilityWait,
	UnemploymentWaitType,
	DisabilityWaitType,
	CoverType,
	PolicyBenefitPeriod,
	BenefitUplift,
	DeferrePremiumLength,
	TotalBenefit,
	MonthlyMortgagePayment,
	OtherCover,
	Customer1Benefit,
	BenefitUpliftAmount,
	ProductToQuote,
	ConcurrencyId,
	QuoteId,
	@StampAction, 
	GetDate(), 
	@StampUser
	
FROM TAsuQuote
WHERE QuoteId = @QuoteId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
