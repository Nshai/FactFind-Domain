CREATE TABLE [dbo].[TPartnershipdetailsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
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
[CRMContactId] [int] NOT NULL,
[PartnershipdetailsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPartnershipdetailsAudit__ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPartnershipdetailsAudit] ADD CONSTRAINT [PK_TPartnershipdetailsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
