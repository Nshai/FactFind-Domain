CREATE TABLE [dbo].[TCreditHistoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL,
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
[CreditHistoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCreditHistoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[LiabilitiesId] [int] NULL
)
GO
ALTER TABLE [dbo].[TCreditHistoryAudit] ADD CONSTRAINT [PK_TCreditHistoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TCreditHistoryAudit_CreditHistoryId_ConcurrencyId] ON [dbo].[TCreditHistoryAudit] ([CreditHistoryId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
