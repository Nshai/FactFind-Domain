CREATE TABLE [dbo].[_MetadataLog](
	[MetadataLogId] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](512) NOT NULL,
	[Hash] [nvarchar](512) NULL,
	[TimeStamp] [datetime] NULL,
 CONSTRAINT [PK_MetadataLog] PRIMARY KEY CLUSTERED 
 (
	[MetadataLogId] ASC
 )
)
GO

ALTER TABLE [dbo].[_MetadataLog] ADD  CONSTRAINT [DF_MetadataLog_TimeStamp]  DEFAULT (getdate()) FOR [TimeStamp]
GO


