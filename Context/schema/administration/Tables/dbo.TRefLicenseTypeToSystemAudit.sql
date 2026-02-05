CREATE TABLE [dbo].[TRefLicenseTypeToSystemAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefLicenseTypeId] [int] NOT NULL,
[SystemId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefLicenseTypeToSystemAudit_ConcurrencyId] DEFAULT ((1)),
[RefLicenseTypeToSystemId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefLicenseTypeToSystemAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefLicenseTypeToSystemAudit] ADD CONSTRAINT [PK_TRefLicenseTypeToSystemAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
