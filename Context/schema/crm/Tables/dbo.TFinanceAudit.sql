CREATE TABLE [dbo].[TFinanceAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Status] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[Stability] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[Earned] [money] NULL,
[Investment] [money] NULL,
[Tax] [money] NULL,
[Expenditure] [money] NULL,
[Possessions] [money] NULL,
[PropertyOwner] [bit] NULL CONSTRAINT [DF_TFinanceAudit_PropertyOwner] DEFAULT ((0)),
[PropertyStatus] [varchar] (32) COLLATE Latin1_General_CI_AS NULL,
[Ethical] [bit] NULL,
[CrmContactId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[FinanceId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinanceAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinanceAudit] ADD CONSTRAINT [PK_TFinanceAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TFinanceAudit_FinanceId_ConcurrencyId] ON [dbo].[TFinanceAudit] ([FinanceId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
