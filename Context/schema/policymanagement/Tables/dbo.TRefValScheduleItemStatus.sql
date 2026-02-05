CREATE TABLE [dbo].[TRefValScheduleItemStatus]
(
[RefValScheduleItemStatusId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefValScheduleItemStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefValScheduleItemStatus] ADD CONSTRAINT [PK_TRefValScheduleItemStatus] PRIMARY KEY NONCLUSTERED  ([RefValScheduleItemStatusId])
GO
