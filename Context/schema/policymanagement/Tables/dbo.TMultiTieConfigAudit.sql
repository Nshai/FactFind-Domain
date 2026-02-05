CREATE TABLE [dbo].[TMultiTieConfigAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[MultiTieConfigId] [int] NULL,
[MultiTieName] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[TenantId] [int] NULL,
[ConcurrencyId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IsArchived] [bit] NULL CONSTRAINT [DF__TMultiTie__IsArc__2B0CC772] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TMultiTieConfigAudit] ADD CONSTRAINT [PK_TMultiTieConfigAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
