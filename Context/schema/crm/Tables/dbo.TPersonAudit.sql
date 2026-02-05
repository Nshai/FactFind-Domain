CREATE TABLE [dbo].[TPersonAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Title] [varchar] (255)  NULL,
[FirstName] [varchar] (255)  NOT NULL,
[MiddleName] [varchar] (255)  NULL,
[LastName] [varchar] (255)  NOT NULL,
[MaidenName] [varchar] (255)  NULL,
[DOB] [datetime] NULL,
[GenderType] [varchar] (255)  NULL,
[NINumber] [varchar] (255)  NULL,
[IsSmoker] [varchar] (10)  NULL,
[UKResident] [tinyint] NULL,
[ResidentIn] [varchar] (50)  NULL,
[Salutation] [varchar] (50)  NULL,
[RefSourceTypeId] [int] NULL,
[IntroducerSource] [varchar] (50)  NULL,
[MaritalStatus] [varchar] (255)  NULL,
[MarriedOn] [datetime] NULL,
[Residency] [varchar] (32)  NULL,
[UKDomicile] [bit] NULL,
[Domicile] [varchar] (32)  NULL,
[TaxCode] [varchar] (12)  NULL,
[Nationality] [varchar] (32)  NULL,
[ArchiveFG] [tinyint] NOT NULL CONSTRAINT [DF_TPersonAudit_ArchiveFG] DEFAULT ((0)),
[Salary] [money] NULL,
[IndClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPersonAudit_ConcurrencyId] DEFAULT ((1)),
[PersonId] [int] NOT NULL,
[StampAction] [char] (1)  NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPersonAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255)  NULL,
[Expatriate] [bit] NULL,
[RefNationalityId] [int] NULL,
[HasSmokedInLast12Months] [bit] NULL,
[IsInGoodHealth] [bit] NULL,
[MigrationRef] [varchar] (255)  NULL,
[IsPowerOfAttorneyGranted] [bit] NULL,
[AttorneyName] [varchar] (255)  NULL,
[IsDisplayTitle] [bit] NULL,
[MaritalStatusSince] [date] NULL,
[NationalClientIdentifier] [varchar](40) NULL,
[CountryCodeOfResidence] [varchar](2) NULL,
[CountryCodeOfDomicile] [varchar](2) NULL,
[InvitationSendDate] [datetime] NULL,
[EverSmoked] [bit] NULL,
[HasVapedorUsedEcigarettesLast1Year] [bit] NULL,
[HaveUsedNicotineReplacementProductsLast1Year] [bit] NULL
)
GO
ALTER TABLE [dbo].[TPersonAudit] ADD CONSTRAINT [PK_TPersonAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPersonAudit_PersonId_ConcurrencyId] ON [dbo].[TPersonAudit] ([PersonId], [ConcurrencyId])
GO
CREATE NONCLUSTERED INDEX [IX_TPersonAudit_StampDateTime_PersonId] ON [dbo].[TPersonAudit] ([StampDateTime], [PersonId])
GO
