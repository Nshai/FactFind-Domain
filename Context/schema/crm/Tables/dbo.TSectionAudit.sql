CREATE TABLE [dbo].[TSectionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [int] NOT NULL,
[Url] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[DetailUrl] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[Editable] [bit] NULL,
[ConcurrencyId] [int] NOT NULL,
[SectionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TSectionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSectionAudit] ADD CONSTRAINT [PK_TSectionAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TSectionAudit_ReviewDefinitionId_ConcurrencyId] ON [dbo].[TSectionAudit] ([SectionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
