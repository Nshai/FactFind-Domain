CREATE TABLE [dbo].[TExecutedDataScript]
(
[ExecutedDataScriptId] [int] NOT NULL IDENTITY(1, 1),
[ScriptGUID] [uniqueidentifier] NOT NULL,
[Comments] [nvarchar] (256) COLLATE Latin1_General_CI_AS NULL,
[TenantId] [int] NULL,
[TimeStamp] [datetime] NULL CONSTRAINT [DF_TExecutedDataScript_TimeStamp] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[TExecutedDataScript] ADD CONSTRAINT [PK_TExecutedDataScript] PRIMARY KEY CLUSTERED  ([ExecutedDataScriptId])
GO
