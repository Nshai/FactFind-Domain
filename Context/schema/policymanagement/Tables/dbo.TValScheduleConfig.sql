CREATE TABLE [dbo].[TValScheduleConfig]
(
[ValScheduleConfigId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NOT NULL,
[ScheduleStartTime] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IsEnabled] [bit] NOT NULL CONSTRAINT [DF_TValScheduleConfig_IsEnabled] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValScheduleConfig_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValScheduleConfig] ADD CONSTRAINT [PK_TValScheduleConfig] PRIMARY KEY NONCLUSTERED  ([ValScheduleConfigId])
GO
CREATE NONCLUSTERED INDEX [IX_TValScheduleConfig_RefProdProviderId] ON [dbo].[TValScheduleConfig] ([RefProdProviderId])
GO
