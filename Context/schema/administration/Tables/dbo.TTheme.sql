CREATE TABLE [dbo].[TTheme]
(
[ThemeId] [uniqueidentifier] NOT NULL,
[Name] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Skin] [int] NOT NULL CONSTRAINT [DF__TTheme__Skin__7FA732A6] DEFAULT ((1)),
[ColourPrimary] [nvarchar] (6) COLLATE Latin1_General_CI_AS NOT NULL,
[ColourSecondary] [nvarchar] (6) COLLATE Latin1_General_CI_AS NOT NULL,
[ColourHighlight] [nvarchar] (6) COLLATE Latin1_General_CI_AS NOT NULL,
[GroupId] [int] NOT NULL CONSTRAINT [DF_TTheme_GroupId] DEFAULT ((0)),
[IsPropagated] [bit] NOT NULL CONSTRAINT [DF_TTheme_IsPropagated] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TTheme] ADD CONSTRAINT [PK_TTheme] PRIMARY KEY CLUSTERED  ([ThemeId])
GO
