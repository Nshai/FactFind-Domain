CREATE TABLE [dbo].[TAnnouncementAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[ShortDesc] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[LongDesc] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[URL] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FromClientId] [int] NULL,
[Date] [datetime] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[AnnouncementId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAnnouncem_StampDateTime_1__55] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAnnouncementAudit] ADD CONSTRAINT [PK_TAnnouncementAudit_2__55] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TAnnouncementAudit_AnnouncementId_ConcurrencyId] ON [dbo].[TAnnouncementAudit] ([AnnouncementId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
