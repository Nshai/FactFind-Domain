CREATE TABLE [dbo].[TAtrRetirementCategory]
(
[AtrRetirementCategoryId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[AtrCategoryId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrRetirementCategory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrRetirementCategory] ADD CONSTRAINT [PK_TAtrRetirementCategory] PRIMARY KEY NONCLUSTERED  ([AtrRetirementCategoryId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrRetirementCategory_CRMContactId] ON [dbo].[TAtrRetirementCategory] ([CRMContactId])
GO
