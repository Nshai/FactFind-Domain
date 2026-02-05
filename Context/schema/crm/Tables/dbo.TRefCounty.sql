CREATE TABLE [dbo].[TRefCounty]
(
[RefCountyId] [int] NOT NULL IDENTITY(1, 1),
[CountyName] [varchar] (255)  NULL,
[RefCountryId] [int] NOT NULL,
[ArchiveFG] [tinyint] NOT NULL CONSTRAINT [DF_TRefCounty_ArchiveFG] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCounty_ConcurrencyId] DEFAULT ((1)),
[CountyCode] [varchar] (10)  NULL,
[ParentCountyCode] [varchar] (10)  NULL
)
GO
ALTER TABLE [dbo].[TRefCounty] ADD CONSTRAINT [PK_TRefCounty] PRIMARY KEY NONCLUSTERED  ([RefCountyId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefCounty_RefCountryId] ON [dbo].[TRefCounty] ([RefCountryId])
GO
CREATE CLUSTERED INDEX [IDX1_TRefCounty_RefCountyId] ON [dbo].[TRefCounty] ([RefCountyId])
GO
ALTER TABLE [dbo].[TRefCounty] WITH CHECK ADD CONSTRAINT [FK_TRefCounty_RefCountryId_RefCountryId] FOREIGN KEY ([RefCountryId]) REFERENCES [dbo].[TRefCountry] ([RefCountryId])
GO
