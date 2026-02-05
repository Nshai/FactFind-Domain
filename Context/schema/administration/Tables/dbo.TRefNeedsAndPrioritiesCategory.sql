CREATE TABLE [dbo].[TRefNeedsAndPrioritiesCategory]
(
[RefNeedsAndPrioritiesCategoryId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefNeedsAndPrioritiesCategory_ConcurrencyId] DEFAULT (1),
[CategoryName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [int] NOT NULL,
[IsCorporate] [bit] NOT NULL,
[CategoryType] [varchar] (25) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefNeedsAndPrioritiesCategory] ADD CONSTRAINT [PK_TRefNeedsAndPrioritiesCategory] PRIMARY KEY CLUSTERED  ([RefNeedsAndPrioritiesCategoryId])
GO
