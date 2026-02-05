CREATE TABLE [dbo].[TRefCasePriority]
(
[RefCasePriorityId] [int] NOT NULL IDENTITY(1, 1),
[CasePriorityName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsDefectPriority] [bit] NOT NULL CONSTRAINT [DF_TRefCasePriority_IsDefectPriority] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCasePriority_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefCasePriority] ADD CONSTRAINT [PK_TRefCasePriority] PRIMARY KEY NONCLUSTERED  ([RefCasePriorityId]) WITH (FILLFACTOR=80)
GO
