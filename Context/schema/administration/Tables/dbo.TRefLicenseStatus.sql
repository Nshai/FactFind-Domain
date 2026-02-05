CREATE TABLE [dbo].[TRefLicenseStatus]
(
[RefLicenseStatusId] [int] NOT NULL IDENTITY(1, 1),
[StatusName] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefLicenseStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefLicenseStatus] ADD CONSTRAINT [PK_TRefLicenseStatus] PRIMARY KEY CLUSTERED  ([RefLicenseStatusId])
GO
