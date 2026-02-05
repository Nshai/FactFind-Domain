CREATE TABLE [dbo].[TRefEvalueModellingType](
	[RefEvalueModellingTypeId] [int] IDENTITY(1,1) NOT NULL,
	[ModellingType] [varchar](50) NOT NULL
)

ALTER TABLE [dbo].[TRefEvalueModellingType] ADD CONSTRAINT [PK_TRefEvalueModellingType] PRIMARY KEY NONCLUSTERED  ([RefEvalueModellingTypeId])
GO
