CREATE TABLE [dbo].[TDataProtectionActAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ConcurrencyId] [int] NULL,
[CRMContactId] [int] NOT NULL,
[IsAwareOfRights] [tinyint] NULL,
[HasGivenConsent] [tinyint] NULL,
[IsAwareOfAccess] [tinyint] NULL,
[DataProtectionActId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDataProtectionActAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDataProtectionActAudit] ADD CONSTRAINT [PK_TDataProtectionActAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
