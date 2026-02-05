CREATE TABLE [dbo].[TEvalueLog]
(
[EvalueLogId] [int] NOT NULL IDENTITY(1, 1),
[UserName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[UserPassword] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[DateRan] [datetime] NOT NULL CONSTRAINT [DF_TEvalueLog_DateRan] DEFAULT (getdate()),
[ModellingStatus] [int] NOT NULL CONSTRAINT [DF_TEvalueLog_ModellingStatus] DEFAULT ((0)),
[RefEvalueLogStatusId] [smallint] NOT NULL CONSTRAINT [DF_TEvalueLog_RefEvalueLogStatusId] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueLog_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEvalueLog] ADD CONSTRAINT [PK_TEvalueLog] PRIMARY KEY NONCLUSTERED  ([EvalueLogId])
GO
CREATE NONCLUSTERED INDEX [IX_TEvalueLog_UserName_UserPassword_RefEvalueLogStatusId] ON [dbo].[TEvalueLog] ([UserName],[UserPassword],[RefEvalueLogStatusId])
go