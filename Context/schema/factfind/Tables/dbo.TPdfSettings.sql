CREATE TABLE [dbo].[TPdfSettings]
(
[PdfSettingsId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPdfSettings_ConcurrencyId] DEFAULT ((1)),
[TenantId] [int] NOT NULL,
[Title] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[SubTitle] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[TitleColour] [varchar] (8) COLLATE Latin1_General_CI_AS NULL,
[SubTitleColour] [varchar] (8) COLLATE Latin1_General_CI_AS NULL,
[ClientOneColour] [varchar] (8) COLLATE Latin1_General_CI_AS NULL,
[ClientTwoColour] [varchar] (8) COLLATE Latin1_General_CI_AS NULL,
[TableHeadingColour] [varchar] (8) COLLATE Latin1_General_CI_AS NULL,
[TableSubHeadingColour] [varchar] (8) COLLATE Latin1_General_CI_AS NULL,
[ShowRefDataOptions] [bit] NULL,
[SectionHeadingBackgroundColour] [varchar] (8) COLLATE Latin1_General_CI_AS NULL,
[LogoAlign] [varchar] (8) COLLATE Latin1_General_CI_AS NULL,
[Acknowledgments] [varchar] (16) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPdfSettings] ADD CONSTRAINT [PK_TPdfSettings] PRIMARY KEY NONCLUSTERED  ([PdfSettingsId])
GO
CREATE CLUSTERED INDEX [IDX_TPdfSettings_TenantId] ON [dbo].[TPdfSettings] ([PdfSettingsId])
GO
