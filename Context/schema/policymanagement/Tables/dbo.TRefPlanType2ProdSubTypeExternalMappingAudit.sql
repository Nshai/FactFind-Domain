CREATE TABLE [dbo].[TRefPlanType2ProdSubTypeExternalMappingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[ExternalCode] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefPlanType2ProdSubTypeExternalMappingId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefPlanType2ProdSubTypeExternalMappingAudit] ADD CONSTRAINT [PK_TRefPlanType2ProdSubTypeExternalMappingAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
