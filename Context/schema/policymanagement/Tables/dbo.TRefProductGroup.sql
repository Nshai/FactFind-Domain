CREATE TABLE [dbo].[TRefProductGroup]
(
[RefProductGroupId] [int] NOT NULL IDENTITY(1, 1),
[ProductGroupName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefProductGroup_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefProductGroup_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefProductGroup] ADD CONSTRAINT [PK_TRefProductGroup] PRIMARY KEY NONCLUSTERED  ([RefProductGroupId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TRefProductGroup] ON [dbo].[TRefProductGroup] ([RefProductGroupId]) WITH (FILLFACTOR=80)
GO
