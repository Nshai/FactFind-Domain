CREATE TABLE [dbo].[TAtrCategoryQuestion]
(
[AtrCategoryQuestionId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[AtrCategoryGuid] [uniqueidentifier] NOT NULL,
[AtrQuestionGuid] [uniqueidentifier] NOT NULL,
[AtrTemplateGuid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrCategoryQuestion_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrCategoryQuestion] ADD CONSTRAINT [PK_TAtrCategoryQuestion] PRIMARY KEY CLUSTERED  ([AtrCategoryQuestionId])
GO
CREATE NONCLUSTERED INDEX IX_TAtrCategoryQuestion_AtrTemplateGuid ON [dbo].[TAtrCategoryQuestion] ([AtrTemplateGuid])
go