CREATE TABLE [dbo].[TPropertyDetail]
(
[PropertyDetailId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPropertyDetail_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NOT NULL,
[CRMContactId2] [int] NULL,
[Owner] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[RelatedAddressStoreId] [int] NULL,
[AddressLine1] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[AddressLine2] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[AddressLine3] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[AddressLine4] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[CityTown] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefCountyId] [int] NULL,
[RefCountryId] [int] NULL,
[Postcode] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsCurrentResidentialAddress] [bit] NULL,
[HouseType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PropertyType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[TenureType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[LeaseholdEndsOn] [datetime] NULL,
[PropertyStatus] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Construction] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[NumberOfBedrooms] [smallint] NULL,
[YearBuilt] [int] NULL,
[IsProspective] [bit] NULL CONSTRAINT [DF_TPropertyDetail_IsProspective] DEFAULT ((0)),
[ConstructionNotes] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RoofConstructionType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RoofConstructionNotes] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsNewBuild] [bit] NULL,
[NHBCCertificateCovered] [bit] NULL,
[OtherCertificateCovered] [bit] NULL,
[CertificateNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[BuilderName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefAdditionalPropertyDetailId] [int] NULL,
[IsExLocalAuthority] [bit] NULL,
[IsOutbuildings] [bit] NULL,
[NumberOfOutbuildings] [int] NULL
)
GO
ALTER TABLE [dbo].[TPropertyDetail] ADD CONSTRAINT [PK_TPropertyDetail] PRIMARY KEY CLUSTERED  ([PropertyDetailId])
GO
CREATE NONCLUSTERED INDEX [IX_TPropertyDetail_CrmContactId] ON [dbo].[TPropertyDetail] ([CrmContactId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TPropertyDetail_CrmContactId2] ON [dbo].[TPropertyDetail] ([CrmContactId2]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TPropertyDetail_AddressStoreId] ON [dbo].[TPropertyDetail] ([RelatedAddressStoreId])


