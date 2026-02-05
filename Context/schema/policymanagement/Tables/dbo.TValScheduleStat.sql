CREATE TABLE [dbo].[TValScheduleStat]
(
[ValScheduleStatId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[ScheduledDate] [datetime] NULL,
[StartTime] [datetime] NULL,
[EndTime] [datetime] NULL,
[ScheduleItemCount] [int] NOT NULL CONSTRAINT [DF_TValScheduleStat_ScheduleItemCount] DEFAULT ((0)),
[IsProcessed] [bit] NOT NULL CONSTRAINT [DF_TValScheduleStat_IsProcessed] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TValScheduleStat] ADD CONSTRAINT [PK_TValScheduleStat] PRIMARY KEY NONCLUSTERED  ([ValScheduleStatId])
GO
