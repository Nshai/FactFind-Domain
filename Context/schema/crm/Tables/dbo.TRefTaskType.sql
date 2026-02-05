CREATE TABLE [dbo].[TRefTaskType]
(
[RefTaskTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[RefCategoryId] [int] NOT NULL,
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefTaskTy_ConcurrencyId_1__54] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefTaskType] ADD CONSTRAINT [PK_TRefTaskType_2__54] PRIMARY KEY NONCLUSTERED  ([RefTaskTypeId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefTaskType_RefCategoryId] ON [dbo].[TRefTaskType] ([RefCategoryId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TRefTaskType] ADD CONSTRAINT [FK_TRefTaskType_RefCategoryId_RefCategoryId] FOREIGN KEY ([RefCategoryId]) REFERENCES [dbo].[TRefCategory] ([RefCategoryId])
GO
