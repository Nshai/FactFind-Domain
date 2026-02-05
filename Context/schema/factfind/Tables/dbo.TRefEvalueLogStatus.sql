CREATE TABLE [dbo].[TRefEvalueLogStatus]
(
[RefEvalueLogStatusId] [int] NOT NULL IDENTITY(1, 1),
[EvalueLogStatus] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueLogStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefEvalueLogStatus] ADD CONSTRAINT [PK_TEvalueLogStatus] PRIMARY KEY NONCLUSTERED  ([RefEvalueLogStatusId])
GO
