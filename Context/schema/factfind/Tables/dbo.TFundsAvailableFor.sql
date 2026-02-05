CREATE TABLE [dbo].[TFundsAvailableFor]
(
[FundsAvailableForId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[LumpSum] [money] NULL,
[MonthlySum] [money] NULL,
[DoYouWantAccessToFunds] [bit] NULL,
[WhenAreTheFunds] [datetime] NULL,
[HowLong] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[FurtherFundsAnticipated] [bit] NULL,
[FurtherFundsAnticipatedAmount] [money] NULL,
[InvestmentRestrictions] [bit] NULL,
[InvestmentRestrictionsNote] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[Notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TFundsAvailableFor__ConcurrencyId] DEFAULT ((1)),
[SourceOfInvestmentFunds] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [IDX_TFundsAvailableFor_CRMContactId] ON [dbo].[TFundsAvailableFor] ([CRMContactId])
GO
