CREATE TABLE [dbo].[TAtr](
	[AtrId] [int] IDENTITY(1,1) NOT NULL,
	[AtrTemplateId] [int] NOT NULL,
	[IndigoClientId] [int] NOT NULL,
	[Context] [nvarchar](255) NOT NULL,
	[CrmContactId] [int] NOT NULL,
	[CrmContactId2] [int] NULL,
	[QuestionAnswerJson] [nvarchar](max) NOT NULL,
	[HasInconsistencyInAnswers] [bit] NULL, 
	[InconsistencyComments] [nvarchar](max) NULL,
	[Score] [int] NULL,
	[GeneratedRiskProfileJson] [nvarchar](max) NULL,
	[ChosenRiskProfileJson] [nvarchar](max) NULL,
	[OriginalAssetModelJson] [nvarchar](max) NULL,
	[InconsistentAnswersJson] [nvarchar](max) NULL,
	[AgreedWithGeneratedRiskProfile] [bit] NULL,
	[Notes] [nvarchar](max) NULL,
	[Status] nvarchar(20) NOT NULL,
	[CompletedBy] int NULL,
	[CompletedAt] [datetime2] NULL,
	[CreatedAt] [datetime2] NULL CONSTRAINT [DF_TAtr_CreatedAt] DEFAULT GETDATE(),
	[MigrationRef][nvarchar](max) NULL CONSTRAINT [DF_TAtr_MigrationRef] DEFAULT (NULL),
	[GeneratedRiskProfileId] [int] NULL,
	[GeneratedRiskProfileName] [varchar](255) NULL,
	[ChosenRiskProfileId] [int] NULL,
	[ChosenRiskProfileName] [varchar](255) NULL,
	CONSTRAINT [PK_TAtr] PRIMARY KEY CLUSTERED 
	(
		[AtrId] ASC
	)
) 
GO

ALTER TABLE [dbo].[TAtr]  WITH CHECK ADD  CONSTRAINT [FK_TAtr_TAtrTemplate_AtrTemplateId] FOREIGN KEY([AtrTemplateId])
REFERENCES [dbo].[TAtrTemplate] ([AtrTemplateId])
GO

CREATE NONCLUSTERED INDEX [IDX_TAtr_IndigoClientId] ON [dbo].[TAtr] ([IndigoClientId])
GO

CREATE NONCLUSTERED INDEX [IDX_TAtr_AtrTemplateId] ON [dbo].[TAtr] ([AtrTemplateId])
GO

ALTER TABLE [dbo].[TAtr] CHECK CONSTRAINT [FK_TAtr_AtrTemplateId]
GO

ALTER TABLE [dbo].[TAtr] ADD  CONSTRAINT [DF_TAtr_Status]  DEFAULT ('Draft') FOR [Status]
GO
ALTER TABLE [dbo].[TAtr]  WITH CHECK ADD  CONSTRAINT [FK_TAtr_TRiskProfile_ChosenRiskProfileId] FOREIGN KEY([ChosenRiskProfileId])
REFERENCES [dbo].[TRiskProfile] ([RiskProfileId])
GO

ALTER TABLE [dbo].[TAtr] CHECK CONSTRAINT [FK_TAtr_TRiskProfile_ChosenRiskProfileId]
GO

ALTER TABLE [dbo].[TAtr]  WITH CHECK ADD  CONSTRAINT [FK_TAtr_TRiskProfile_GeneratedRiskProfileId] FOREIGN KEY([GeneratedRiskProfileId])
REFERENCES [dbo].[TRiskProfile] ([RiskProfileId])
GO

ALTER TABLE [dbo].[TAtr] CHECK CONSTRAINT [FK_TAtr_TRiskProfile_GeneratedRiskProfileId]
GO

CREATE NONCLUSTERED INDEX IDX_TAtr_GeneratedRiskProfileId ON [dbo].[TAtr] ([GeneratedRiskProfileId])
GO

CREATE NONCLUSTERED INDEX IDX_TAtr_ChosenRiskProfileId ON [dbo].[TAtr] ([ChosenRiskProfileId])
GO
