CREATE TABLE [dbo].[TRefLicenseTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LicenseTypeName] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[RefLicenseStatusId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefLicenseTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefLicenseTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefLicenseTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefLicenseTypeAudit] ADD CONSTRAINT [PK_TRefLicenseTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
