CREATE TABLE [dbo].[TLegacyTheme_201005200954]
(
[LegacyThemeId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[DefaultFont] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[DefaultSize] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[AlternateFont] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[AlternateSize] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Colour1] [nvarchar] (6) COLLATE Latin1_General_CI_AS NOT NULL,
[Colour2] [nvarchar] (6) COLLATE Latin1_General_CI_AS NOT NULL,
[Colour3] [nvarchar] (6) COLLATE Latin1_General_CI_AS NOT NULL,
[Colour4] [nvarchar] (6) COLLATE Latin1_General_CI_AS NOT NULL,
[Colour5] [nvarchar] (6) COLLATE Latin1_General_CI_AS NOT NULL,
[Colour6] [nvarchar] (6) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
