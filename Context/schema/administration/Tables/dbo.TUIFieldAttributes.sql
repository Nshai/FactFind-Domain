CREATE TABLE [dbo].[TUIFieldAttributes]
(
[UIFieldAttributesId][int] NOT NULL IDENTITY(1, 1),
[UIFieldNameId] [int] NOT NULL,
[AttributesName] [varchar](100) NOT NULL,
[AttributesValue] [varchar](100) NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUIFieldAttributes_ConcurrencyId] DEFAULT ((1))
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TUIFieldAttributes_TenantId] ON [dbo].[TUIFieldAttributes] ([TenantId])
GO


