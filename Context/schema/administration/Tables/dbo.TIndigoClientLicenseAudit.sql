CREATE TABLE [dbo].[TIndigoClientLicenseAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LicenseTypeId] [int] NOT NULL,
[Status] [bit] NOT NULL,
[MaxConUsers] [int] NULL,
[MaxULAGCount] [int] NULL,
[UADRestriction] [bit] NOT NULL,
[MaxULADCount] [int] NULL,
[AdviserCountRestrict] [bit] NOT NULL,
[MaxAdviserCount] [int] NULL,
[MaxFinancialPlanningUsers] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientLicenseId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MaxAdvisaCentaCoreUsers] [int] NULL,
[MaxAdvisaCentaCorePlusLifetimePlannerUsers] [int] NULL
)
GO
ALTER TABLE [dbo].[TIndigoClientLicenseAudit] ADD CONSTRAINT [PK_TIndigoClientLicenseAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
