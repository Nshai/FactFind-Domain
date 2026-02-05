CREATE TABLE [dbo].[TUserExtendedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[MigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUserExtendedAudit_ConcurrencyId] DEFAULT ((1)),
[UserExtendedId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TUserExtendedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TUserExtendedAudit] ADD CONSTRAINT [PK_TUserExtendedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TUserExtendedAudit_UserExtendedId_ConcurrencyId] ON [dbo].[TUserExtendedAudit] ([UserExtendedId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
