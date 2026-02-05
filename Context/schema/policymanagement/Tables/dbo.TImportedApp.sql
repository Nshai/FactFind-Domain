CREATE TABLE [dbo].[TImportedApp](
	[ImportedAppId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[Summary] [varchar](255)  NULL,
	[Description] [varchar](max)  NULL,
	[Code] [varchar](100) NOT NULL,
	[Role] [varchar](100) NOT NULL,
	[AppId] [varchar](100) NOT NULL CONSTRAINT [DF_TImportedApp_AppId] DEFAULT ('Not Added'),
	[IsUpdated] [bit] NOT NULL CONSTRAINT [DF_TImportedApp_IsUpdated] DEFAULT (0),
	[IsPublished] [bit] NOT NULL CONSTRAINT [DF_TImportedApp_IsPublished] DEFAULT (0),
	[IsInstalled] [bit] NOT NULL CONSTRAINT [DF_TImportedApp_IsInstalled] DEFAULT (0),	
	[InstalledTenants][varchar](max) NULL,	
	[Remarks] [varchar](max) NULL,
	[Json] [varchar](max) NULL,
	[Icon] [varchar](255) NULL,
	[IconBytes] [varbinary](max) NULL,
	[IconUpdated]  [bit] NULL,
	[Audience][varchar](max) NOT NULL CONSTRAINT [DF_TImportedApp_Audience] Default('{"publishTenants":["publish-all"],"installTenants":["install-all"]}'),
	[IsAdded] [bit] NOT NULL CONSTRAINT [DF_TImportedApp_IsAdded]  DEFAULT ((0)),
 CONSTRAINT [PK_TImportedApp] PRIMARY KEY CLUSTERED 
(
	[ImportedAppId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



