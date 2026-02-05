CREATE TABLE [dbo].[TExternalApplicationUserSessionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[UserId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[SessionId] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[LastAccessed] [datetime] NULL,
[IP] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[ExternalApplication] [varchar](100) NULL,
[ConcurrencyId] [int] NOT NULL ,
[ExternalApplicationUserSessionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TExternalApplicationUserSessionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
)
GO
ALTER TABLE [dbo].[TExternalApplicationUserSessionAudit] ADD CONSTRAINT [PK_TExternalApplicationUserSessionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
