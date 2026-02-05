CREATE TABLE [dbo].[TClientSectionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[SectionId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[ClientSectionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TClientSectionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TClientSectionAudit] ADD CONSTRAINT [PK_TClientSectionAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TClientSectionAudit_ClientSectionId_ConcurrencyId] ON [dbo].[TClientSectionAudit] ([ClientSectionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
