CREATE TABLE [dbo].[TRefEvalueAssetClassAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefEvalueAssetClassId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefEvalueAssetClassAudit] ADD CONSTRAINT [PK_TRefEvalueAssetClassAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
