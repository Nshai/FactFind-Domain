SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditInvestmentGoalsNeedsQuestion]
	@StampUser varchar (255),
	@InvestmentGoalsNeedsQuestionId bigint,
	@StampAction char(1)
AS

INSERT INTO TInvestmentGoalsNeedsQuestionAudit 
(CRMContactId, ConcurrencyId, IsThereAWishToPlaceInvestmentInTrust, IsTransferToPartnerConsidered, IsCapitalGainsTaxUtilised, IsThereASpecificInvestmentPreference, 
	IsFutureMoneyAnticipated, IsInheritanceTaxPlanningConsidered,
	InvestmentGoalsNeedsQuestionId, StampAction, StampDateTime, StampUser)
SELECT  CRMContactId, ConcurrencyId, IsThereAWishToPlaceInvestmentInTrust, IsTransferToPartnerConsidered, IsCapitalGainsTaxUtilised, IsThereASpecificInvestmentPreference, 
	IsFutureMoneyAnticipated, IsInheritanceTaxPlanningConsidered,
	InvestmentGoalsNeedsQuestionId, @StampAction, GetDate(), @StampUser
FROM TInvestmentGoalsNeedsQuestion
WHERE InvestmentGoalsNeedsQuestionId = @InvestmentGoalsNeedsQuestionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
