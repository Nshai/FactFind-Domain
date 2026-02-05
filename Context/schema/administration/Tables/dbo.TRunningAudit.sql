CREATE TABLE [dbo].[TRunningAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RebuildKeys] [bit] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RunningId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRunningAudit] ADD CONSTRAINT [PK_TRunningAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRunningAudit_RunningId_ConcurrencyId] ON [dbo].[TRunningAudit] ([RunningId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
