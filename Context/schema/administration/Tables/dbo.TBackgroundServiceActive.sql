CREATE TABLE [dbo].[TBackgroundServiceActive]
(
[BackgroundServiceActiveId] [int] NOT NULL IDENTITY(1, 1),
[EntityName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[EntityId] [int] NULL,
[StartDateTime] [datetime] NOT NULL CONSTRAINT [DF_TBackgroundServiceActive_StartDateTime] DEFAULT (getdate()),
[ServerName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[UserId] [char] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TBackgroundServiceActive_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TBackgroundServiceActive] ADD CONSTRAINT [PK_TBackgroundServiceActive] PRIMARY KEY NONCLUSTERED  ([BackgroundServiceActiveId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TBackgroundServiceActive] ON [dbo].[TBackgroundServiceActive] ([BackgroundServiceActiveId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TBackgroundServiceActive_Identifier] ON [dbo].[TBackgroundServiceActive] ([Identifier]) WITH (FILLFACTOR=80)
GO
