CREATE TABLE [dbo].[TEmptyTemplatesBackup]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
TemplateGuid UNIQUEIDENTIFIER,
BaseTemplateGuid UNIQUEIDENTIFIER,
Stage    VARCHAR(15)
)
GO

