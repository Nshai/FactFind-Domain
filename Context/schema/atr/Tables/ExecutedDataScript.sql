CREATE TABLE [dbo].[TExecutedDataScript](
	[ExecutedDataScriptId] [int] IDENTITY(1,1) NOT NULL,
	[ScriptGUID] [uniqueidentifier] NOT NULL,
	[Comments] [nvarchar](256) NULL,
	[TenantId] [int] NULL,
	[TimeStamp] [datetime] NULL,
 CONSTRAINT [PK_TExecutedDataScript] PRIMARY KEY CLUSTERED 
 (
	[ExecutedDataScriptId] ASC
 )
) 
GO

ALTER TABLE [dbo].[TExecutedDataScript] ADD  CONSTRAINT [DF_TExecutedDataScript_TimeStamp]  DEFAULT (getdate()) FOR [TimeStamp]
GO


