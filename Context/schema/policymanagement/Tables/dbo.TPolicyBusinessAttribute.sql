CREATE TABLE [dbo].[TPolicyBusinessAttribute]
(
[PolicyBusinessAttributeId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[AttributeList2AttributeId] [int] NOT NULL,
[AttributeValue] [varchar] (255)  NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBusinessAttribute_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPolicyBusinessAttribute] ADD CONSTRAINT [PK_TPolicyBusinessAttribute] PRIMARY KEY NONCLUSTERED  ([PolicyBusinessAttributeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusinessAttribute_AttributeList2AttributeId] ON [dbo].[TPolicyBusinessAttribute] ([AttributeList2AttributeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusinessAttribute_PolicyBusinessId] ON [dbo].[TPolicyBusinessAttribute] ([PolicyBusinessId])
GO
CREATE CLUSTERED INDEX [IDX1_TPolicyBusinessAttribute_PolicyBusinessId] ON [dbo].[TPolicyBusinessAttribute] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TPolicyBusinessAttribute] WITH CHECK ADD CONSTRAINT [FK_TPolicyBusinessAttribute_AttributeList2AttributeId_AttributeList2AttributeId] FOREIGN KEY ([AttributeList2AttributeId]) REFERENCES [dbo].[TAttributeList2Attribute] ([AttributeList2AttributeId])
GO
ALTER TABLE [dbo].[TPolicyBusinessAttribute] WITH CHECK ADD CONSTRAINT [FK_TPolicyBusinessAttribute_PolicyBusinessId_PolicyBusinessId] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
