CREATE TABLE [dbo].[TAnnouncement]
(
[AnnouncementId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[ShortDesc] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[LongDesc] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[URL] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FromClientId] [int] NULL,
[Date] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAnnouncem_ConcurrencyId_1__56] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAnnouncement] ADD CONSTRAINT [PK_TAnnouncement_2__56] PRIMARY KEY NONCLUSTERED  ([AnnouncementId]) WITH (FILLFACTOR=80)
GO
