CREATE TABLE [dbo].[TRole]
(
[RoleId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (64)  NOT NULL,
[GroupingId] [int] NOT NULL,
[SuperUser] [bit] NOT NULL CONSTRAINT [DF_TRole_SuperUser] DEFAULT ((0)),
[IndigoClientId] [int] NOT NULL,
[RefLicenseTypeId] [int] NULL,
[LicensedUserCount] [int] NOT NULL CONSTRAINT [DF_TRole_LicensedUserCount] DEFAULT ((0)),
[Dashboard] [varchar] (255)  NULL,
[ShowGroupDashboard] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRole_ConcurrencyId] DEFAULT ((1)),
[HourlyBillingRate] [money] NULL,
[HasGroupDataAccess] [bit] NOT NULL CONSTRAINT [DF_TRole_HasGroupDataAccess] DEFAULT ((0)),
)
GO
ALTER TABLE [dbo].[TRole] ADD CONSTRAINT [PK_TRole] PRIMARY KEY CLUSTERED  ([RoleId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRole_GroupingId] ON [dbo].[TRole] ([GroupingId])
GO
CREATE NONCLUSTERED INDEX [IX_TRole_RefLicenseTypeId] ON [dbo].[TRole] ([RefLicenseTypeId])
GO
ALTER TABLE [dbo].[TRole] WITH CHECK ADD CONSTRAINT [FK_TRole_IndigoClientId_IndigoClientId] FOREIGN KEY ([IndigoClientId]) REFERENCES [dbo].[TIndigoClient] ([IndigoClientId])
GO
ALTER TABLE [dbo].[TRole] WITH CHECK ADD CONSTRAINT [FK_TRole_TRefLicenseType_RefLicenseTypeId] FOREIGN KEY ([RefLicenseTypeId]) REFERENCES [dbo].[TRefLicenseType] ([RefLicenseTypeId])
GO
CREATE NONCLUSTERED INDEX IX_TRole_IndigoClientId ON [dbo].[TRole] ([IndigoClientId])
GO
