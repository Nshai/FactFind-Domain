CREATE TABLE [dbo].[TSoletraderdetails]
(
[SoletraderdetailsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Name] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AddressLine1] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AddressLine2] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AddressLine3] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AddressLine4] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CityTown] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Postcode] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CountryCode] [varchar] (2) COLLATE Latin1_General_CI_AS NULL,
[CountyCode] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
[Smoker] [bit] NULL,
[DOB] [datetime] NULL,
[hasFamilyMembers] [bit] NULL,
[FamilyMemberName] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[FamilyMemberRelationship] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[FamilyMemberDuties] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[IncorporateYesNo] [bit] NULL,
[Value] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[InGoodHealth] [bit] NULL,
[AnyoneNeedProtection] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TSoletraderdetails__ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TSoletraderdetails_CRMContactId] ON [dbo].[TSoletraderdetails] ([CRMContactId])
GO
