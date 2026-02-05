CREATE TABLE [dbo].[TClientShareNoteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ClientShareNoteId] [int] NOT NULL,
[Notes] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[LastEditedBy] [int] NULL,
[LastEditedDate] [datetime] NULL,
[ClientShareId] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientShareNoteAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TClientShareNoteAudit] ADD CONSTRAINT [PK_TClientShareNoteAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
