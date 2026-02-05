CREATE TABLE [dbo].[TDebtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ShortTermDebt] [money] NULL,
[LongTermDebt] [money] NULL,
[ShortDeathProtection] [bit] NULL,
[ShortSicknessProtection] [bit] NULL,
[ShortUnemploymentProtection] [bit] NULL,
[LongDeathProtection] [bit] NULL,
[LongSicknessProtection] [bit] NULL,
[LongUnemploymentProtection] [bit] NULL,
[Arrears] [bit] NULL,
[Judgements] [bit] NULL,
[Joint] [bit] NULL,
[ClearedPreRetire] [bit] NULL,
[ClearedPreRetireDetail] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CrmContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[DebtId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDebtAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDebtAudit] ADD CONSTRAINT [PK_TDebtAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TDebtAudit_DebtId_ConcurrencyId] ON [dbo].[TDebtAudit] ([DebtId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
