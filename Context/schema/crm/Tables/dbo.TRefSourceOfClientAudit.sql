CREATE TABLE [dbo].[TRefSourceOfClientAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[SourceType] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[IndClientId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefSourceOfClientId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefSource_StampDateTime_1__54] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefSourceOfClientAudit] ADD CONSTRAINT [PK_TRefSourceOfClientAudit_2__54] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefSourceOfClientAudit_RefSourceOfClientId_ConcurrencyId] ON [dbo].[TRefSourceOfClientAudit] ([RefSourceOfClientId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
