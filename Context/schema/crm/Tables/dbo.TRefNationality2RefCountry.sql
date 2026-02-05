CREATE TABLE [dbo].[TRefNationality2RefCountry]
(
[RefNationality2RefCountryId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefNationalityId] [int] NOT NULL,
[RefCountryId] [int] NOT NULL,
[Descriptor] [nvarchar] (255) COLLATE Latin1_General_CI_AS  NOT NULL,
[ISOAlpha2Code] [nvarchar] (10) COLLATE Latin1_General_CI_AS  NULL,
[ISOAlpha3Code] [nvarchar] (10) COLLATE Latin1_General_CI_AS  NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefNationality2RefCountry_ConcurrencyId_2__54] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefNationality2RefCountry] ADD CONSTRAINT [PK_TRefNationality2RefCountry_3__54] PRIMARY KEY NONCLUSTERED  ([RefNationality2RefCountryId]) WITH (FILLFACTOR=80)
GO

