CREATE TABLE [dbo].[TCreditHistory]
(
[CreditHistoryId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCreditHistory_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NOT NULL,
[Owner] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[Type] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[DateRegistered] [datetime] NULL,
[DateDischarged] [datetime] NULL,
[DateRepossessed] [datetime] NULL,
[DateSatisfied] [datetime] NULL,
[AmountRegistered] [money] NULL,
[AmountOutstanding] [money] NULL,
[NumberOfPaymentsMissed] [smallint] NULL,
[NumberOfPaymentsInArrears] [smallint] NULL,
[AreArrearsClearedUponCompletion] [bit] NULL,
[IsDebtOutstanding] [bit] NULL,
[IsIvaCurrent] [bit] NULL,
[YearsMaintained] [smallint] NULL,
[Lender] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[LiabilitiesId] [int] NULL
)
GO
ALTER TABLE [dbo].[TCreditHistory] ADD CONSTRAINT [PK_TCreditHistory] PRIMARY KEY NONCLUSTERED  ([CreditHistoryId])
GO
