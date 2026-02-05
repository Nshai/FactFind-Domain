CREATE TABLE [dbo].[TPFPGroupThemeConfigurationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[GroupThemeConfigId] [int] NOT NULL,
[TenantId] [int] NULL,
[GroupId] [int] NULL,
[Theme] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPFPGroupThemeConfigurationAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL CONSTRAINT [DF_TPFPGroupThemeConfigurationAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPFPGroupThemeConfigurationAudit] ADD CONSTRAINT [PK_TPFPGroupThemeConfigurationAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
