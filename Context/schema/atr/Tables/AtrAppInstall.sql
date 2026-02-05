CREATE TABLE [dbo].[TAtrAppInstall](
	[AtrAppInstallId] [int] IDENTITY(1,1) NOT NULL,
	[IndigoClientId] [int] NOT NULL,
	[AppId] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2] NOT NULL,
	[UpdatedAt] [datetime2] NOT NULL,
 CONSTRAINT [PK_TAtrAppInstall] PRIMARY KEY CLUSTERED 
 (
	[AtrAppInstallId] ASC
 )
) 
GO

ALTER TABLE [dbo].[TAtrAppInstall] ADD  CONSTRAINT [DF_TAtrAppInstall_CreatedAt]  DEFAULT (GetUTCDate()) FOR [CreatedAt]
GO

ALTER TABLE [dbo].[TAtrAppInstall] ADD  CONSTRAINT [DF_TAtrAppInstall_UpdatedAt]  DEFAULT (GetUTCDate()) FOR [UpdatedAt]
GO


