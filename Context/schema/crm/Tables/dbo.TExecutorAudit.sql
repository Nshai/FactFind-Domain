CREATE TABLE [dbo].[TExecutorAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EstatePlanningId] [int] NULL,
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[ExecutorId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TExecutorA_StampDateTime_1__53] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TExecutorAudit] ADD CONSTRAINT [PK_TExecutorAudit_2__53] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TExecutorAudit_ExecutorId_ConcurrencyId] ON [dbo].[TExecutorAudit] ([ExecutorId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
