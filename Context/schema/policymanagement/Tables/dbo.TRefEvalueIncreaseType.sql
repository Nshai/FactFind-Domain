CREATE TABLE [dbo].[TRefEvalueIncreaseType]
(
[RefEvalueIncreaseTypeId] [int] NOT NULL IDENTITY(1, 1),
[IncreaseType] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefEvalueIncreaseType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefEvalueIncreaseType] ADD CONSTRAINT [PK_TRefEvalueIncreaseType] PRIMARY KEY CLUSTERED  ([RefEvalueIncreaseTypeId])
GO
