CREATE TABLE [dbo].[TLegacyTheme]
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
ALTER TABLE [dbo].[TLegacyTheme] ADD CONSTRAINT [PK_TLegacyTheme] PRIMARY KEY CLUSTERED  ([LegacyThemeId])
GO
ALTER TABLE [dbo].[TLegacyTheme] ADD CONSTRAINT [FK_TLegacyTheme_IndigoClient] FOREIGN KEY ([IndigoClientId]) REFERENCES [dbo].[TIndigoClient] ([IndigoClientId])
GO
