CREATE TABLE [dbo].[TTabName]
(
[TabNameId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ArchiveFg] [tinyint] NULL,
[ASPPage] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PersonFg] [tinyint] NULL,
[CorporateFg] [tinyint] NULL,
[TrustFg] [tinyint] NULL,
[IndClientId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TTabName_ConcurrencyId_1__54] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TTabName] ADD CONSTRAINT [PK_TTabName_2__54] PRIMARY KEY NONCLUSTERED  ([TabNameId]) WITH (FILLFACTOR=80)
GO
