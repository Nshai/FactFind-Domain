CREATE TABLE [dbo].[TInvestmentGoalsNeedsQuestion]
(
[InvestmentGoalsNeedsQuestionId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TInvestmentGoalsNeedsQuestion_ConcurrencyId] DEFAULT ((1)),
[IsThereAWishToPlaceInvestmentInTrust] [bit] NULL,
[IsTransferToPartnerConsidered] [bit] NULL,
[IsCapitalGainsTaxUtilised] [bit] NULL,
[IsThereASpecificInvestmentPreference] [bit] NULL,
[IsFutureMoneyAnticipated] [bit] NULL,
[IsInheritanceTaxPlanningConsidered] [bit] NULL
)
GO
ALTER TABLE [dbo].[TInvestmentGoalsNeedsQuestion] ADD CONSTRAINT [PK_TInvestmentGoalsNeedsQuestion] PRIMARY KEY NONCLUSTERED  ([InvestmentGoalsNeedsQuestionId])
GO
