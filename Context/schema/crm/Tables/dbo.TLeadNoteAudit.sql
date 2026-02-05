CREATE TABLE [dbo].[TLeadNoteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LeadNoteId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[LeadId] [int] NOT NULL,
[Text] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[CreatedOn] [datetime] NOT NULL,
[CreatedBy] [int] NOT NULL,
[UpdatedOn] [datetime] NOT NULL,
[UpdatedBy] [int] NOT NULL,
[IsSystem] [bit] NOT NULL CONSTRAINT [DF_TLeadNoteAudit_IsSystem] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLeadNoteAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TLeadNoteAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLeadNoteAudit] ADD CONSTRAINT [PK_TLeadNoteAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IX_TLeadNoteAudit_LeadId_TenantId] ON [dbo].[TLeadNoteAudit] ([LeadId], [TenantId])
GO
