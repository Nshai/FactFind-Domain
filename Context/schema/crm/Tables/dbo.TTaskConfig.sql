CREATE TABLE [dbo].[TTaskConfig]
(
[TaskConfigId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[AllowAutoAllocation] [bit] NOT NULL CONSTRAINT [DF_TTaskConfig_AllowAutoAllocation] DEFAULT ((0)),
[MaxTasksPerUser] [int] NOT NULL CONSTRAINT [DF_TTaskConfig_MaxTasksPerUser] DEFAULT ((0)),
[AssignedToDefault] [varchar] (30) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_TTaskConfig_AssignedToDefault] DEFAULT ('User'),
[LockDefault] [bit] NOT NULL CONSTRAINT [DF_TTaskConfig_LockDefault] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTaskConfig_ConcurrencyId] DEFAULT ((1)),
[ShowinDiaryDefault] [bit] NOT NULL CONSTRAINT [DF__TTaskConf__Showi__71297349] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TTaskConfig] ADD CONSTRAINT [PK_TTaskConfig] PRIMARY KEY NONCLUSTERED  ([TaskConfigId])
GO
