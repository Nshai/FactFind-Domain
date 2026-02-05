CREATE TABLE [dbo].[TProfessionalContact]
(
[ProfessionalContactId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ContactType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ContactName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[CompanyName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[AddressLine1] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[AddressLine2] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[AddressLine3] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[AddressLine4] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[CityTown] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[County] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[CountyCode] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
[PostCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[TelephoneNumber] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FascimileNumber] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[MobileNumber] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[EmailAddress] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProfessionalContact_ConcurrencyId] DEFAULT ((1)),
[PermissionToContact] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[IsSourceOfFunds] [bit] NULL
)
GO
ALTER TABLE [dbo].[TProfessionalContact] ADD CONSTRAINT [PK_TProfessionalContact] PRIMARY KEY NONCLUSTERED  ([ProfessionalContactId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TProfessionalContact_CRMContactId] ON [dbo].[TProfessionalContact] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
