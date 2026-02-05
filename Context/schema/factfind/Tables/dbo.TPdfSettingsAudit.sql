CREATE TABLE [dbo].[TPdfSettingsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPdfSettingsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PdfSettingsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
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
ALTER TABLE [dbo].[TPdfSettingsAudit] ADD CONSTRAINT [PK_TPdfSettingsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
