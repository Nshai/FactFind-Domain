USE [atr]
GO

/****** Object:  Table [dbo].[TAtr_Bkp]    Script Date: 05-09-2023 15:36:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TAtr_Bkp](
	[Atr_BkpId] [int] IDENTITY(1,1) NOT NULL,
	[AtrId] [int] NOT NULL,
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
	[Notes] [nvarchar](max) NULL,
	[CompletedAt] [datetime2](7) NULL,
	[Status] [nvarchar](20) NOT NULL,
	[CompletedBy] [int] NULL,
	[InconsistentAnswersJson] [nvarchar](max) NULL,
	[AgreedWithGeneratedRiskProfile] [bit] NULL,
	[MigrationRef] [nvarchar](max) NULL,
	[CreatedAt] [datetime2](7) NULL,
	)
GO



