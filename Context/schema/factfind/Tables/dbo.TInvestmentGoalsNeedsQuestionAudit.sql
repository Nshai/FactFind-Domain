CREATE TABLE [dbo].[TInvestmentGoalsNeedsQuestionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[InvestmentGoalsNeedsQuestionId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[IsThereAWishToPlaceInvestmentInTrust] [bit] NULL,
[IsTransferToPartnerConsidered] [bit] NULL,
[IsCapitalGainsTaxUtilised] [bit] NULL,
[IsThereASpecificInvestmentPreference] [bit] NULL,
[IsFutureMoneyAnticipated] [bit] NULL,
[IsInheritanceTaxPlanningConsidered] [bit] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL CONSTRAINT [DF_TInvestmentGoalsNeedsQuestion_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TInvestmentGoalsNeedsQuestionAudit] ADD CONSTRAINT [PK_TInvestmentGoalsNeedsQuestionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
