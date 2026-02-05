CREATE TABLE [dbo].[TAtrInvestmentCategory]
(
[AtrInvestmentCategoryId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[AtrCategoryId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrInvestmentCategory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrInvestmentCategory] ADD CONSTRAINT [PK_TAtrInvestmentCategory] PRIMARY KEY NONCLUSTERED  ([AtrInvestmentCategoryId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrInvestmentCategory_CRMContactId] ON [dbo].[TAtrInvestmentCategory] ([CRMContactId])
GO
