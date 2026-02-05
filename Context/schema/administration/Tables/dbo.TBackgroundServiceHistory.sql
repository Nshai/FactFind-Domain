CREATE TABLE [dbo].[TBackgroundServiceHistory]
(
[BackgroundServiceHistoryId] [int] NOT NULL IDENTITY(1, 1),
[EntityName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[EntityId] [int] NULL,
[OtherInfo] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[StartDateTime] [datetime] NOT NULL CONSTRAINT [DF_TBackgroundServiceHistory_StartDateTime] DEFAULT (getdate()),
[EndDateTime] [datetime] NULL,
[ServerName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[UserId] [int] NOT NULL,
[RefBackgroundServiceStatusId] [int] NOT NULL,
[DataVersion] [int] NULL CONSTRAINT [DF_TBackgroundServiceHistory_DataVersion] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TBackgroundServiceHistory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TBackgroundServiceHistory] ADD CONSTRAINT [PK_TBackgroundServiceHistory] PRIMARY KEY NONCLUSTERED  ([BackgroundServiceHistoryId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TBackgroundServiceHistory] ON [dbo].[TBackgroundServiceHistory] ([BackgroundServiceHistoryId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TBackgroundServiceHistory_Identifier] ON [dbo].[TBackgroundServiceHistory] ([Identifier]) WITH (FILLFACTOR=80)
GO
