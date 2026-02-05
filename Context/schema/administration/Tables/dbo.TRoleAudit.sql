CREATE TABLE [dbo].[TRoleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Identifier] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[GroupingId] [int] NOT NULL,
[SuperUser] [bit] NOT NULL CONSTRAINT [DF_TRoleAudit_SuperUser] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[IndigoClientId] [int] NOT NULL,
[RefLicenseTypeid] [int] NULL,
[LicensedUserCount] [int] NOT NULL CONSTRAINT [DF_TRoleAudit_LicensedUserCount] DEFAULT ((0)),
[Dashboard] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ShowGroupDashboard] [bit] NULL,
[HourlyBillingRate] [money] NULL,
[RoleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRoleAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[HasGroupDataAccess] [bit] NOT NULL CONSTRAINT [DF_TRoleAudit_HasGroupDataAccess] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRoleAudit] ADD CONSTRAINT [PK_TRoleAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRoleAudit_RoleId_ConcurrencyId] ON [dbo].[TRoleAudit] ([RoleId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
