CREATE TABLE [dbo].[TRefCategory]
(
[RefCategoryId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCatego_ConcurrencyId_1__54] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefCategory] ADD CONSTRAINT [PK_TRefCategory_2__54] PRIMARY KEY NONCLUSTERED  ([RefCategoryId]) WITH (FILLFACTOR=80)
GO
