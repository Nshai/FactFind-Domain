CREATE TABLE [dbo].[TProductConnectionSetting]
(
[ProductConnectionSettingId] [int] NOT NULL IDENTITY(1, 1),
[ProgId] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AsyncFG] [bit] NULL,
[AsyncAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[SyncAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ResponseAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[SendQueue] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ResponseQueueSync] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ResponseQueueAsync] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MessagePrefix] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[MessageSuffix] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[UrlEncodeFG] [bit] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProductCo_ConcurrencyId_1__63] DEFAULT ((1)),
[UserName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Password] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProductConnectionSetting] ADD CONSTRAINT [PK_TProductConnectionSettings_2__63] PRIMARY KEY NONCLUSTERED  ([ProductConnectionSettingId]) WITH (FILLFACTOR=80)
GO
