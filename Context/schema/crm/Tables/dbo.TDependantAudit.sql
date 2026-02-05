CREATE TABLE [dbo].[TDependantAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL,
[DoB] [datetime] NOT NULL,
[IndependenceAge] [int] NULL,
[CrmContactId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[DependantId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDependantAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDependantAudit] ADD CONSTRAINT [PK_TDependantAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TDependantAudit_DebtId_ConcurrencyId] ON [dbo].[TDependantAudit] ([DependantId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
