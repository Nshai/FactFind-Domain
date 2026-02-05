CREATE TABLE [dbo].[TRefPlanTypeAttribute]
(
[RefPlanTypeAttributeId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanTypeId] [int] NOT NULL,
[AttributeListId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanType2AttributeList_ConcurrencyId] DEFAULT ((1)),
[IsVisible] [bit] NOT NULL CONSTRAINT [DF_TRefPlanTypeAttribute_IsVisible] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPlanTypeAttribute] 
ADD CONSTRAINT [PK_TRefPlanType2AttributeList] 
PRIMARY KEY NONCLUSTERED  ([RefPlanTypeAttributeId]) 
WITH (FILLFACTOR=80)
GO

CREATE NONCLUSTERED INDEX [IDX_TRefPlanTypeAttribute_AttributeListId] 
ON [dbo].[TRefPlanTypeAttribute] ([AttributeListId]) 
WITH (FILLFACTOR=80)
GO

CREATE NONCLUSTERED INDEX [IDX_TRefPlanTypeAttribute_RefPlanTypeId] 
ON [dbo].[TRefPlanTypeAttribute] ([RefPlanTypeId]) 
WITH (FILLFACTOR=80)
GO

ALTER TABLE [dbo].[TRefPlanTypeAttribute] 
ADD CONSTRAINT [FK_TRefPlanTypeAttribute_AttributeListId_AttributeListId] 
FOREIGN KEY ([AttributeListId]) 
REFERENCES [dbo].[TAttributeList] ([AttributeListId])
GO

ALTER TABLE [dbo].[TRefPlanTypeAttribute] 
ADD CONSTRAINT [FK_TRefPlanTypeAttribute_RefPlanTypeId_RefPlanTypeId] 
FOREIGN KEY ([RefPlanTypeId]) 
REFERENCES [dbo].[TRefPlanType] ([RefPlanTypeId])
GO