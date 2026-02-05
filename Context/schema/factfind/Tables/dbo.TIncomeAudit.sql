CREATE TABLE [dbo].[TIncomeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[IsChangeExpected] [bit] NULL,
[IsRiseExpected] [bit] NULL,
[ChangeAmount] [money] NULL,
[ChangeReason] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IncomeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIncomeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIncomeAudit] ADD CONSTRAINT [PK_TIncomeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
