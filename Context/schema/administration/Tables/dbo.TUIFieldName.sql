CREATE TABLE [dbo].[TUIFieldName]
(
[UIFieldNameId] [int] NOT NULL IDENTITY(1, 1),
[UIDomainId] [int] NOT NULL,
[FieldName] [varchar](100) NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUIFieldName_ConcurrencyId] DEFAULT ((1))
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TUIFieldName_TenantId] ON [dbo].[TUIFieldName] ([TenantId])
GO


