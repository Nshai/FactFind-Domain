CREATE TABLE [dbo].[TAtrAppTemplate](
	[AtrAppTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[AppId] [varchar](50) NULL,
	[AppName] [varchar](255) NULL,
	[AtrQuestionAnswerJson] [nvarchar](max) NOT NULL,
	[AtrAssetModelId] [int] NULL,
	[RiskGroupJson] [nvarchar](max) NULL,
	[InconsistentAnswers] [nvarchar](max) NULL,
	[RiskProfileJson] [nvarchar](max) NULL,
	[CreatedAt] [datetime2] NOT NULL,
	[UpdatedAt] [datetime2] NOT NULL,
	[MigrationRef][nvarchar](max) NULL,
 CONSTRAINT [PK_TAtrAppTemplate] PRIMARY KEY CLUSTERED 
 (
	[AtrAppTemplateId] ASC
 )
) 
GO

ALTER TABLE [dbo].[TAtrAppTemplate] ADD  CONSTRAINT [DF_TAtrAppTemplate_CreatedAt]  DEFAULT (GetUTCDate()) FOR [CreatedAt]
GO

ALTER TABLE [dbo].[TAtrAppTemplate] ADD  CONSTRAINT [DF_TAtrAppTemplate_UpdatedAt]  DEFAULT (GetUTCDate()) FOR [UpdatedAt]
GO

ALTER TABLE [dbo].[TAtrAppTemplate]  WITH CHECK ADD  CONSTRAINT [FK_TAtrAppTemplate_TAtrAssetModel_AtrAssetModelId] FOREIGN KEY([AtrAssetModelId])
REFERENCES [dbo].[TAtrAssetModel] ([AtrAssetModelId])
GO

ALTER TABLE [dbo].[TAtrAppTemplate] CHECK CONSTRAINT [FK_TAtrAppTemplate_TAtrAssetModel]
GO


