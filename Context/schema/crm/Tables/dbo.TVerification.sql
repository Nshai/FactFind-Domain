CREATE TABLE [dbo].[TVerification]
(
[VerificationId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PlaceOfBirth] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CountryOfBirth] [varchar](2) NULL,
[MothersMaidenName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ElectricityBillSeen] [datetime] NULL,
[ElectricityBillRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[DrivingLicenceSeen] [datetime] NULL,
[DrivingLicenceRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[MicroficheIssueDate] [datetime] NULL,
[MicroficheNumber] [varchar] (14) COLLATE Latin1_General_CI_AS NULL,
[PassportSeen] [datetime] NULL,
[CountryOfOrigin] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PassportRef] [varchar] (44) COLLATE Latin1_General_CI_AS NULL,
[PassportExpiryDate] [datetime] NULL,
[HomeVisit] [datetime] NULL,
[PremisesEntered] [datetime] NULL,
[MortgageStatementSeen] [datetime] NULL,
[CouncilTaxBillSeen] [datetime] NULL,
[UtilitiesBillSeen] [datetime] NULL,
[UtilitiesBillRef] [varchar](50) NULL,
[IRTaxNotificationSeen] [datetime] NULL,
[Comments] [text] COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TVerification_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NULL,
[DrivingLicenceExpiryDate] [datetime] NULL,
[PractitionerId] [int] NULL,
[WitnessPosition] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[WitnessedDate] [datetime] NULL,
[PlaceOfBirthOther] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[BankStatementSeen] [datetime] NULL,
[FirearmOrShotgunCertificateRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FirearmOrShotgunCertificateSeen] [datetime] NULL,
[FirearmOrShotgunCertificateExpiryDate] [datetime] NULL,
[VerificationExpiryDate] [datetime] NULL,
)
GO
ALTER TABLE [dbo].[TVerification] ADD CONSTRAINT [PK_TVerification] PRIMARY KEY NONCLUSTERED  ([VerificationId])
GO
CREATE NONCLUSTERED INDEX [IX_TVerification_CRMContactId] ON [dbo].[TVerification] ([CRMContactId])
GO
