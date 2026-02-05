CREATE TABLE [dbo].[TExpenditureAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[IsDetailed] [bit] NULL,
[NetMonthlySummaryAmount] [money] NULL,
[IsChangeExpected] [bit] NULL,
[IsRiseExpected] [bit] NULL,
[ChangeAmount] [money] NULL,
[ChangeReason] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ExpenditureId] [int] NOT NULL,
[HasFactFindLiabilitiesImported] [bit] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TExpenditureAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TExpenditureAudit] ADD CONSTRAINT [PK_TExpenditureAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
