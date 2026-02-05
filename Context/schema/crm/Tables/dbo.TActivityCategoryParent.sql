CREATE TABLE [dbo].[TActivityCategoryParent]
(
[ActivityCategoryParentId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityCategoryParent_ConcurrencyId] DEFAULT ((1)),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF__TActivity__IsArc__60F30B80] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TActivityCategoryParent] ADD CONSTRAINT [PK_TActivityCategoryParent_ActivityCategoryParentId] PRIMARY KEY NONCLUSTERED  ([ActivityCategoryParentId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TActivityCategoryParent_IndigoClientId_IsArchived] ON [dbo].[TActivityCategoryParent] ([IndigoClientId],[IsArchived])
GO

CREATE NONCLUSTERED INDEX [IX_TActivityCategoryParent_IndigoClientId] ON [dbo].[TActivityCategoryParent] ([IndigoClientId])
GO
