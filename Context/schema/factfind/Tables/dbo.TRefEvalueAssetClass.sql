CREATE TABLE [dbo].[TRefEvalueAssetClass]
(
[RefEvalueAssetClassId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TRefEvalueAssetClass] ADD CONSTRAINT [PK_TRefEvalueAssetClass] PRIMARY KEY CLUSTERED  ([RefEvalueAssetClassId])
GO
