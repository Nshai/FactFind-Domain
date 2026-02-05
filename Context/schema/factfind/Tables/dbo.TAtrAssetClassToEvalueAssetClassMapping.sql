CREATE TABLE [dbo].[TAtrAssetClassToEvalueAssetClassMapping]
(
[AtrAssetClassToEvalueAssetClassMappingId] [int] NOT NULL IDENTITY(1, 1),
[RefEvalueAssetClassId] [int] NOT NULL,
[AtrRefAssetClassId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TAtrAssetClassToEvalueAssetClassMapping] ADD CONSTRAINT [PK_TAtrAssetClassToEvalueAssetClassMapping] PRIMARY KEY CLUSTERED  ([AtrAssetClassToEvalueAssetClassMappingId])
GO
