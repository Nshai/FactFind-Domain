CREATE TABLE [dbo].[TRefCountry]
(
[RefCountryId] [int] NOT NULL IDENTITY(1, 1),
[CountryName] [varchar] (255)  NOT NULL,
[ArchiveFG] [tinyint] NOT NULL CONSTRAINT [DF_TRefCountr_ArchiveFG] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCountr_ConcurrencyId] DEFAULT ((1)),
[CountryCode] [varchar] (10)  NULL
)
GO
ALTER TABLE [dbo].[TRefCountry] ADD CONSTRAINT [PK_TRefCountry] PRIMARY KEY CLUSTERED  ([RefCountryId])
GO
CREATE NONCLUSTERED INDEX [IX_TRefCountry_CountryName_RefCountryID] ON [dbo].[TRefCountry] ([CountryName], [RefCountryId])
GO
