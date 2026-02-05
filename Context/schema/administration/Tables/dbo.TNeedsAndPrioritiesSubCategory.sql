CREATE TABLE [dbo].[TNeedsAndPrioritiesSubCategory]
(
[NeedsAndPrioritiesSubCategoryId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TNeedsAndPrioritiesSubCategory_ConcurrencyId] DEFAULT ((1)),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NOT NULL,
[Ordinal] [int] NULL
)
GO
ALTER TABLE [dbo].[TNeedsAndPrioritiesSubCategory] ADD CONSTRAINT [PK_TNeedsAndPrioritiesSubCategory] PRIMARY KEY CLUSTERED ([NeedsAndPrioritiesSubCategoryId])
GO
