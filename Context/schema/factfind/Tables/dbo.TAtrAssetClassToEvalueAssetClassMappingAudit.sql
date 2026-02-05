CREATE TABLE [dbo].[TAtrAssetClassToEvalueAssetClassMappingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefEvalueAssetClassId] [int] NULL,
[AtrRefAssetClassId] [int] NULL,
[AtrAssetClassToEvalueAssetClassMappingId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrAssetClassToEvalueAssetClassMappingAudit] ADD CONSTRAINT [PK_TAtrAssetClassToEvalueAssetClassMappingAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
