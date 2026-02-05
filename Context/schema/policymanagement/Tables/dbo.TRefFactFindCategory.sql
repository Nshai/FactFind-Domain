CREATE TABLE [dbo].[TRefFactFindCategory]
(
[RefFactFindCategoryId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Identfier] [varchar] (24) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefFactFindCategory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefFactFindCategory] ADD CONSTRAINT [PK_TRefFactFindCategory] PRIMARY KEY NONCLUSTERED  ([RefFactFindCategoryId]) WITH (FILLFACTOR=80)
GO
