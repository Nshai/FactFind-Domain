CREATE TABLE [dbo].[TRefNetworkAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CompanyName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[CompanyId] [int] NOT NULL,
[ArchiveFG] [tinyint] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefNetwor_ConcurrencyId_2__56] DEFAULT ((1)),
[RefNetworkId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefNetwor_StampDateTime_3__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefNetworkAudit] ADD CONSTRAINT [PK_TRefNetworkAudit_4__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefNetworkAudit_RefNetworkId_ConcurrencyId] ON [dbo].[TRefNetworkAudit] ([RefNetworkId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
