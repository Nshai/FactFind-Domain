CREATE TABLE [dbo].[TActivityCategory2RefSystemEvent]
(
[ActivityCategory2RefSystemEventId] [int] NOT NULL IDENTITY(1, 1),
[ActivityCategoryId] [int] NOT NULL,
[RefSystemEventId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityCategory2RefSystemEvent_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TActivityCategory2RefSystemEvent] ADD CONSTRAINT [PK_TActivityCategory2RefSystemEvent] PRIMARY KEY NONCLUSTERED  ([ActivityCategory2RefSystemEventId])
GO
CREATE NONCLUSTERED INDEX [IX_TActivityCategory2RefSystemEvent_ActivityCategoryId] ON [dbo].[TActivityCategory2RefSystemEvent] ([ActivityCategoryId])
GO
Create Index IX_TActivityCategory2RefSystemEvent_ActivityCategoryId_RefSystemEventId ON [TActivityCategory2RefSystemEvent] (ActivityCategoryId,RefSystemEventId)
GO
ALTER TABLE [dbo].[TActivityCategory2RefSystemEvent] WITH CHECK ADD CONSTRAINT [FK_TActivityCategory2RefSystemEvent_TActivityCategory] FOREIGN KEY ([ActivityCategoryId]) REFERENCES [dbo].[TActivityCategory] ([ActivityCategoryId])
GO
ALTER TABLE [dbo].[TActivityCategory2RefSystemEvent] ADD CONSTRAINT [FK_TActivityCategory2RefSystemEvent_TRefSystemEvent] FOREIGN KEY ([RefSystemEventId]) REFERENCES [dbo].[TRefSystemEvent] ([RefSystemEventId])
GO
