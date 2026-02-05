CREATE TABLE [dbo].[TServerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[Protocol] [char] (8) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_TServerAudit_Protocol] DEFAULT ('http'),
[IPAddress] [char] (16) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TServerAudit_ConcurrencyId] DEFAULT ((1)),
[ServerId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TServerAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TServerAudit] ADD CONSTRAINT [PK_TServerAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
