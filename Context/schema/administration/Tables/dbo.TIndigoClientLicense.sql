CREATE TABLE [dbo].[TIndigoClientLicense]
(
[IndigoClientLicenseId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[LicenseTypeId] [int] NOT NULL,
[Status] [bit] NOT NULL,
[MaxConUsers] [int] NULL,
[MaxULAGCount] [int] NULL,
[UADRestriction] [bit] NOT NULL,
[MaxULADCount] [int] NULL,
[AdviserCountRestrict] [bit] NOT NULL,
[MaxAdviserCount] [int] NULL,
[MaxFinancialPlanningUsers] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndigoClientLicense_ConcurrencyId] DEFAULT ((1)),
[MaxAdvisaCentaCoreUsers] [int] NULL,
[MaxAdvisaCentaCorePlusLifetimePlannerUsers] [int] NULL
)
GO
ALTER TABLE [dbo].[TIndigoClientLicense] ADD CONSTRAINT [PK_TIndigoClientLicense_IndigoClientLicenseId] PRIMARY KEY NONCLUSTERED  ([IndigoClientLicenseId])
GO
ALTER TABLE [dbo].[TIndigoClientLicense] WITH CHECK ADD CONSTRAINT [FK_TIndigoClientLicense_TRefLicenseType_RefLicenseTypeId] FOREIGN KEY ([LicenseTypeId]) REFERENCES [dbo].[TRefLicenseType] ([RefLicenseTypeId])
GO
