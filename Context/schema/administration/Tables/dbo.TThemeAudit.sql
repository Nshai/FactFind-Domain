CREATE TABLE [dbo].[TThemeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Skin] [int] NOT NULL CONSTRAINT [DF__TThemeAudi__Skin__13AE2B53] DEFAULT ((1)),
[ColourPrimary] [nvarchar] (6) COLLATE Latin1_General_CI_AS NOT NULL,
[ColourSecondary] [nvarchar] (6) COLLATE Latin1_General_CI_AS NOT NULL,
[ColourHighlight] [nvarchar] (6) COLLATE Latin1_General_CI_AS NOT NULL,
[ThemeId] [uniqueidentifier] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF__TThemeAud__Stamp__14A24F8C] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[GroupId] [int] NOT NULL CONSTRAINT [DF_TThemeAudit_GroupId] DEFAULT ((0)),
[IsPropagated] [bit] NOT NULL CONSTRAINT [DF_TThemeAudit_IsPropagated] DEFAULT ((0))
)
GO
