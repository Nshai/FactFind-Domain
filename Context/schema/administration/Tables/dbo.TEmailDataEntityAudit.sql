CREATE TABLE [dbo].[TEmailDataEntityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Path] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEmailDataEntityAudit_ConcurrencyId] DEFAULT ((1)),
[EmailDataEntityId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEmailDataEntityAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEmailDataEntityAudit] ADD CONSTRAINT [PK_TEmailDataEntityAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
