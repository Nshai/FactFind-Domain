CREATE TABLE [dbo].[TBackgroundServiceHistoryItem]
(
[BackgroundServiceHistoryItemId] [int] NOT NULL IDENTITY(1, 1),
[BackgroundServiceHistoryId] [int] NOT NULL,
[StartDateTime] [datetime] NOT NULL CONSTRAINT [DF_TBackgroundServiceHistoryItem_StartDateTime] DEFAULT (getdate()),
[EndDateTime] [datetime] NULL,
[ErrorMessage] [varchar] (3000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TBackgroundServiceHistoryItem_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TBackgroundServiceHistoryItem] ADD CONSTRAINT [PK_TBackgroundServiceHistoryItem] PRIMARY KEY NONCLUSTERED  ([BackgroundServiceHistoryItemId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TBackgroundServiceHistoryItem] ON [dbo].[TBackgroundServiceHistoryItem] ([BackgroundServiceHistoryItemId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TBackgroundServiceHistoryItem] ADD CONSTRAINT [FK_TBackgroundServiceHistoryItem_TBackgroundServiceHistory] FOREIGN KEY ([BackgroundServiceHistoryId]) REFERENCES [dbo].[TBackgroundServiceHistory] ([BackgroundServiceHistoryId])
GO
