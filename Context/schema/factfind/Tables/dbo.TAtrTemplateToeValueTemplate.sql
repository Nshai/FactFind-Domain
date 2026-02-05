CREATE TABLE [dbo].[TAtrTemplateToeValueTemplate]
(
[AtrTemplateToeValueTemplateId] [int] NOT NULL IDENTITY(1, 1),
[AtrTemplateGuid] [uniqueidentifier] NOT NULL,
[RefEValueAtrTemplateId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrTemplateToeValueTemplate_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrTemplateToeValueTemplate] ADD CONSTRAINT [PK_TAtrTemplateToeValueTemplate] PRIMARY KEY CLUSTERED  ([AtrTemplateToeValueTemplateId])
GO
