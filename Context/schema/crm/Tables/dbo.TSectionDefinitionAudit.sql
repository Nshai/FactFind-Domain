CREATE TABLE [dbo].[TSectionDefinitionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ReviewDefinitionId] [int] NOT NULL,
[SectionId] [int] NOT NULL,
[Description] [varchar] (32) COLLATE Latin1_General_CI_AS NULL,
[Ordinal] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[SectionDefinitionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TSectionDefinitionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSectionDefinitionAudit] ADD CONSTRAINT [PK_TSectionDefinitionAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TSectionDefinitionAudit_SectionDefinitionId_ConcurrencyId] ON [dbo].[TSectionDefinitionAudit] ([SectionDefinitionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
