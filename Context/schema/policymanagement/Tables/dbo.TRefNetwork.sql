CREATE TABLE [dbo].[TRefNetwork]
(
[RefNetworkId] [int] NOT NULL IDENTITY(1, 1),
[CompanyName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[CompanyId] [int] NOT NULL,
[ArchiveFG] [tinyint] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefNetwor_ConcurrencyId_1__56] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefNetwork] ADD CONSTRAINT [PK_TRefNetwork_2__56] PRIMARY KEY NONCLUSTERED  ([RefNetworkId]) WITH (FILLFACTOR=80)
GO
