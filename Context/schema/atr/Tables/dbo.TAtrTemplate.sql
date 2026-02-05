CREATE TABLE [dbo].[TAtrTemplate](
	[AtrTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[IndigoClientId] [int] NOT NULL,
	[GroupId] [int] NOT NULL,
	[IncludeSubGroups] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[AppId] [varchar](50) NULL,
	[AppName] [varchar](255) NULL,
	[AtrAppTemplateId] [int] NULL,
	[AtrQuestionAnswerJson] [nvarchar](max) NOT NULL,
	[AtrAssetModelId] [int] NULL,
	[RiskGroupJson] [nvarchar](max) NULL,
	[InconsistentAnswers] [nvarchar](max) NULL,
	[RiskProfileJson] [nvarchar](max) NULL,
	[CreatedAt] [datetime2] NOT NULL,
	[UpdatedAt] [datetime2] NOT NULL,
	[CreatedBy] [int] NULL,
	[MigrationRef][nvarchar](max) NULL CONSTRAINT [DF_TAtrTemplate_MigrationRef] DEFAULT (NULL),
	[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TAtrTemplate_IsArchived] DEFAULT(0),
	[RetakeInterval] [int] NULL,
 CONSTRAINT [PK_TAtrTemplate] PRIMARY KEY CLUSTERED 
 (
	[AtrTemplateId] ASC
 )
) 
GO

ALTER TABLE [dbo].[TAtrTemplate] ADD  CONSTRAINT [DF_TAtrTemplate_CreatedAt]  DEFAULT (GetUTCDate()) FOR [CreatedAt]
GO

ALTER TABLE [dbo].[TAtrTemplate] ADD  CONSTRAINT [DF_TAtrTemplate_UpdatedAt]  DEFAULT (GetUTCDate()) FOR [UpdatedAt]
GO

ALTER TABLE [dbo].[TAtrTemplate]  WITH CHECK ADD  CONSTRAINT [FK_TAtrTemplate_TAtrAssetModel_TAtrAssetModel] FOREIGN KEY([AtrAssetModelId])
REFERENCES [dbo].[TAtrAssetModel] ([AtrAssetModelId])
GO

CREATE NONCLUSTERED INDEX [IDX_TAtrTemplate_IndigoClientId] ON [dbo].[TAtrTemplate] ([IndigoClientId])
GO

ALTER TABLE [dbo].[TAtrTemplate] CHECK CONSTRAINT [FK_TAtrTemplate_TAtrAssetModel]
GO


