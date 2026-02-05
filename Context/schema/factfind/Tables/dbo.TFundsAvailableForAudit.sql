CREATE TABLE [dbo].[TFundsAvailableForAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
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
[CRMContactId] [int] NOT NULL,
[FundsAvailableForId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TFundsAvailableForAudit__ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[SourceOfInvestmentFunds] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFundsAvailableForAudit] ADD CONSTRAINT [PK_TFundsAvailableForAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
