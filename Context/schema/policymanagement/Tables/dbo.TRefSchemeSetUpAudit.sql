CREATE TABLE [dbo].[TRefSchemeSetUpAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Descriptor] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFG] [bit] NOT NULL,
[DPMapping] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefSchemeSetUpId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefSchemeSetUpAudit] ADD CONSTRAINT [PK_TRefSchemeSetUpAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
