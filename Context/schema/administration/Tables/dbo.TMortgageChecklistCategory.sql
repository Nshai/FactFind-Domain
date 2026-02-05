CREATE TABLE [dbo].[TMortgageChecklistCategory]
(
[MortgageChecklistCategoryId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[MortgageChecklistCategoryName] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NOT NULL,
[ArchiveFG] [bit] NOT NULL CONSTRAINT [DF_TMortgageChecklistCategory_ArchiveFG] DEFAULT ((0)),
[Ordinal] [int] NULL,
[SystemFG] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageChecklistCategory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMortgageChecklistCategory] ADD CONSTRAINT [PK_TMortgageChecklistCategory] PRIMARY KEY CLUSTERED  ([MortgageChecklistCategoryId])
GO
