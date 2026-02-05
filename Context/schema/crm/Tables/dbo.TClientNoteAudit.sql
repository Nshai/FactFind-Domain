CREATE TABLE [dbo].[TClientNoteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ClientNoteId] [int] NOT NULL,
[ClientId] [int] NOT NULL,
[Text] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[CreatedOn] [datetime] NOT NULL,
[CreatedBy] [int] NOT NULL,
[UpdatedOn] [datetime] NULL,
[UpdatedBy] [int] NULL,
[PublishToPFP] [bit] NULL,
[IsKeyNote] [bit] NULL,
[IsSystem] [bit] NULL,
[MigrationRef] [varchar] (150) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TClientNoteAudit_ConcurrencyId] DEFAULT ((1)),
[JointClientId][int] NULL,
[IsCriticalNote] [bit] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TClientNoteAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[TenantId] [int] NOT NULL,
)
GO
ALTER TABLE [dbo].[TClientNoteAudit] ADD CONSTRAINT [PK_TClientNoteAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IX_TClientNoteAudit_TenantId_ClientId] ON [dbo].[TClientNoteAudit] ([TenantId],[ClientId])
GO
CREATE NONCLUSTERED INDEX [IX_TClientNoteAudit_TenantId_ClientNoteId] ON [dbo].[TClientNoteAudit] ([TenantId],[ClientNoteId])
GO
