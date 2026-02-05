CREATE TABLE [dbo].[TEvalueError]
(
[EvalueErrorId] [int] NOT NULL IDENTITY(1, 1),
[EvalueLogId] [int] NOT NULL,
[EvalueErrorDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[EvalueErrorXML] [xml] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueError_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEvalueError] ADD CONSTRAINT [PK_TEvalueError] PRIMARY KEY NONCLUSTERED  ([EvalueErrorId])
GO
