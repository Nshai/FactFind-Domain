CREATE TABLE [dbo].[TRefLicenseStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[StatusName] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefLicenseStatusAudit_ConcurrencyId] DEFAULT ((1)),
[RefLicenseStatusId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefLicenseStatusAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefLicenseStatusAudit] ADD CONSTRAINT [PK_TRefLicenseStatusAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
