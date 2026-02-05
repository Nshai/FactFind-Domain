CREATE TABLE [dbo].[TTabNameAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ArchiveFg] [tinyint] NULL,
[ASPPage] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PersonFg] [tinyint] NULL,
[CorporateFg] [tinyint] NULL,
[TrustFg] [tinyint] NULL,
[IndClientId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL,
[TabNameId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TTabNameAu_StampDateTime_1__57] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTabNameAudit] ADD CONSTRAINT [PK_TTabNameAudit_2__57] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TTabNameAudit_TabNameId_ConcurrencyId] ON [dbo].[TTabNameAudit] ([TabNameId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
