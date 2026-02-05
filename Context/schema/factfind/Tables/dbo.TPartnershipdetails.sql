CREATE TABLE [dbo].[TPartnershipdetails]
(
[PartnershipdetailsId] [int] NOT NULL IDENTITY(1, 1),
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
[PercentageInterest] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[InGoodHealth] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPartnershipdetails__ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TPartnershipdetails_CRMContactId] ON [dbo].[TPartnershipdetails] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
