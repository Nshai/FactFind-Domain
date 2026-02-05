CREATE TABLE [dbo].[TAwkwardUserAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[UserId] [int] NOT NULL,
[IsExempt] [bit] NOT NULL CONSTRAINT [DF_TAwkwardUserAudit_IsExempt] DEFAULT ((0)),
[DateAdded] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAwkwardUserAudit_ConcurrencyId] DEFAULT ((1)),
[AwkwardUserId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAwkwardUserAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAwkwardUserAudit] ADD CONSTRAINT [PK_TAwkwardUserAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAwkwardUserAudit_AwkwardUserId_ConcurrencyId] ON [dbo].[TAwkwardUserAudit] ([AwkwardUserId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
