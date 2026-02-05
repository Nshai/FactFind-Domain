CREATE TABLE [dbo].[TLightHouse_CORPORATE]
(
[CorporateId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NULL,
[CorporateName] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[ArchiveFg] [tinyint] NULL,
[BusinessType] [varchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[RefCorporateTypeId] [int] NULL,
[CompanyRegNo] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[EstIncorpDate] [datetime] NULL,
[YearEnd] [datetime] NULL,
[VatRegFg] [tinyint] NULL,
[VatRegNo] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Extensible] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
