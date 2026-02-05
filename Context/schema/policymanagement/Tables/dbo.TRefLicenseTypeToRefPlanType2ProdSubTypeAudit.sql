CREATE TABLE [dbo].[TRefLicenseTypeToRefPlanType2ProdSubTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefLicenseTypeId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefLicenseTypeToRefPlanType2ProdSubTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefLicenseTypeToRefPlanType2ProdSubTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefLicenseTypeToRefPlanType2ProdSubTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefLicenseTypeToRefPlanType2ProdSubTypeAudit] ADD CONSTRAINT [PK_TRefLicenseTypeToRefPlanType2ProdSubTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
