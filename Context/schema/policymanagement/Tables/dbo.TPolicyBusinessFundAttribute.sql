CREATE TABLE [dbo].[TPolicyBusinessFundAttribute]
(
[PolicyBusinessFundAttributeId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessFundId] [int] NOT NULL,
[RefFundAttributeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBusinessFundAttribute_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPolicyBusinessFundAttribute] ADD CONSTRAINT [PK_TPolicyBusinessFundAttribute] PRIMARY KEY NONCLUSTERED  ([PolicyBusinessFundAttributeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusinessFundAttribute_PolicyBusinessFundAttributeId] ON [dbo].[TPolicyBusinessFundAttribute] ([PolicyBusinessFundAttributeId])
GO
CREATE CLUSTERED INDEX [IDX_TPolicyBusinessFundAttribute_PolicyBusinessFundId] ON [dbo].[TPolicyBusinessFundAttribute] ([PolicyBusinessFundId])
GO
CREATE NONCLUSTERED INDEX [IX_TPolicyBusinessFundAttribute_PolicyBusinessFundId_RefFundAttributeId] ON [dbo].[TPolicyBusinessFundAttribute] ([PolicyBusinessFundId], [RefFundAttributeId])
GO
ALTER TABLE [dbo].[TPolicyBusinessFundAttribute] ADD CONSTRAINT [FK_TPolicyBusinessFundAttribute_PolicyBusinessFundId_PolicyBusinessFundId] FOREIGN KEY ([PolicyBusinessFundId]) REFERENCES [dbo].[TPolicyBusinessFund] ([PolicyBusinessFundId])
GO
ALTER TABLE [dbo].[TPolicyBusinessFundAttribute] ADD CONSTRAINT [FK_TPolicyBusinessFundAttribute_RefFundAttributeId_RefFundAttributeId] FOREIGN KEY ([RefFundAttributeId]) REFERENCES [dbo].[TRefFundAttribute] ([RefFundAttributeId])
GO
