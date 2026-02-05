CREATE TABLE [dbo].[TPerson]
(
[PersonId] [int] NOT NULL IDENTITY(1, 1),
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
[ArchiveFG] [tinyint] NOT NULL CONSTRAINT [DF_TPerson_ArchiveFG] DEFAULT ((0)),
[IndClientId] [int] NOT NULL,
[Salary] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPerson_ConcurrencyId] DEFAULT ((1)),
[Expatriate] [bit] NULL,
[RefNationalityId] [int] NULL,
[HasSmokedInLast12Months] [bit] NULL,
[IsInGoodHealth] [bit] NULL,
[MigrationRef] [varchar] (255)  NULL,
[IsPowerOfAttorneyGranted] [bit] NULL,
[AttorneyName] [varchar] (255)  NULL,
[IsDisplayTitle] [bit] NULL CONSTRAINT [DF_TPerson_IsDisplayTitle] DEFAULT ((0)),
[MaritalStatusSince] [date] NULL,
[CreatedOn] [datetime] NULL CONSTRAINT [DF_TPerson_CreatedOn] DEFAULT (getdate()),
[CreatedByUserId] [int] NULL,
[UpdatedOn] [datetime] NULL CONSTRAINT [DF_TPerson_UpdatedOn] DEFAULT (getdate()),
[UpdatedByUserId] [int] NULL,
[NationalClientIdentifier] [varchar](40) NULL,
[CountryCodeOfResidence] [varchar](2) NULL,
[CountryCodeOfDomicile] [varchar](2) NULL,
[InvitationSendDate] [datetime] NULL,
[EverSmoked] [bit] NULL,
[HasVapedorUsedEcigarettesLast1Year] [bit] NULL,
[HaveUsedNicotineReplacementProductsLast1Year] [bit] NULL
)
GO
ALTER TABLE [dbo].[TPerson] ADD CONSTRAINT [PK_TPerson] PRIMARY KEY CLUSTERED  ([PersonId]) 
GO
CREATE NONCLUSTERED INDEX [IDX_TPerson_NINumber] ON [dbo].[TPerson] ([NINumber]) 
GO
CREATE NONCLUSTERED INDEX [IX_TPerson_PersonId_Title] ON [dbo].[TPerson] ([PersonId], [Title])
GO
create index IX_TPerson_IndClientID_MigrationRef on Tperson(IndClientId,MigrationRef) 
go 
CREATE NONCLUSTERED INDEX [IX_TPerson_PersonId_Title_1] ON [dbo].[TPerson] ([PersonId], [Title], LastName)
GO
