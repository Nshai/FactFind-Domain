CREATE TABLE [dbo].[TMultiTieConfigToAdviserAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[MultiTieConfigToAdviserId] [int] NULL,
[MultiTieConfigId] [int] NULL,
[AdviserId] [int] NULL,
[TenantId] [int] NULL,
[ConcurrencyId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMultiTieConfigToAdviserAudit] ADD CONSTRAINT [PK_TMultiTieConfigToAdviserAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
