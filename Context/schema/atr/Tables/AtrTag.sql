CREATE TABLE [dbo].[TAtrTag](
	[TagId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[AtrTemplateId] [int] NOT NULL,
	[CreatedAt] [datetime2] NOT NULL,
	[UpdatedAt] [datetime2] NOT NULL,
	[MigrationRef][nvarchar](max) NULL CONSTRAINT [DF_TAtrTag_MigrationRef] DEFAULT (NULL),
 CONSTRAINT [PK_TAtrTag] PRIMARY KEY CLUSTERED 
 (
	[TagId] ASC
 ) 
) 
GO

ALTER TABLE [dbo].[TAtrTag] ADD  CONSTRAINT [DF_TAtrTag_CreatedAt]  DEFAULT (GetUTCDate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[TAtrTag] ADD  CONSTRAINT [DF_TAtrTag_UpdatedAt]  DEFAULT (GetUTCDate()) FOR [UpdatedAt]
GO

ALTER TABLE [dbo].[TAtrTag]  WITH CHECK ADD  CONSTRAINT [FK_TAtrTag_AtrTemplateId] FOREIGN KEY([AtrTemplateId])
REFERENCES [dbo].[TAtrTemplate] ([AtrTemplateId])
GO

ALTER TABLE [dbo].[TAtrTag] CHECK CONSTRAINT [FK_TAtrTag_TAtrTemplate_AtrTemplateId]
GO


