CREATE TABLE [dbo].[TRefLifeCoverAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefLifeCover] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefLifeCoverId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefLifeCoverAudit] ADD CONSTRAINT [PK_TRefLifeCoverAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefLifeCoverAudit_RefLifeCoverId_ConcurrencyId] ON [dbo].[TRefLifeCoverAudit] ([RefLifeCoverId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
