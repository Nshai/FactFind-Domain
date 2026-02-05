CREATE TABLE [dbo].[TRiskProfile]
(
	[RiskProfileId] [int] IDENTITY(1,1) NOT NULL,
	[IndigoClientId] [int] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[AppId] [varchar](50) NULL,
	[AppName] [varchar](255) NULL,
	[Description] [nvarchar](3000) NULL,
	[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRiskProfile_IsArchived] DEFAULT(0),
	[GroupId] [int] NULL,
	[GroupName] [nvarchar](255) NULL,
	[IncludeSubGroups] [bit] NULL
		CONSTRAINT [PK_TRiskProfile] PRIMARY KEY CLUSTERED 
 (
	[RiskProfileId] ASC
 )
) 
GO

CREATE NONCLUSTERED INDEX [IDX_TRiskProfile_IndigoClientId] ON [dbo].[TRiskProfile] ([IndigoClientId])
GO

CREATE NONCLUSTERED INDEX [IDX_TRiskProfile_AppId] ON [dbo].[TRiskProfile] ([AppId])
GO

CREATE NONCLUSTERED INDEX [IDX_TRiskProfile_IsArchived] ON [dbo].[TRiskProfile] ([IsArchived])
GO