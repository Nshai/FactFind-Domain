CREATE TABLE [dbo].[TAttributeList2Attribute]
(
[AttributeList2AttributeId] [int] NOT NULL IDENTITY(1, 1),
[AttributeListId] [int] NOT NULL,
[AttributeId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAttributeList2Attribute_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAttributeList2Attribute] ADD CONSTRAINT [PK_TAttributeList2Attribute] PRIMARY KEY NONCLUSTERED  ([AttributeList2AttributeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAttributeList2Attribute_AttributeId] ON [dbo].[TAttributeList2Attribute] ([AttributeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAttributeList2Attribute_AttributeListId] ON [dbo].[TAttributeList2Attribute] ([AttributeListId])
GO
ALTER TABLE [dbo].[TAttributeList2Attribute] WITH CHECK ADD CONSTRAINT [FK_TAttributeList2Attribute_AttributeId_AttributeId] FOREIGN KEY ([AttributeId]) REFERENCES [dbo].[TAttribute] ([AttributeId])
GO
ALTER TABLE [dbo].[TAttributeList2Attribute] WITH CHECK ADD CONSTRAINT [FK_TAttributeList2Attribute_AttributeListId_AttributeListId] FOREIGN KEY ([AttributeListId]) REFERENCES [dbo].[TAttributeList] ([AttributeListId])
GO
