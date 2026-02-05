CREATE TABLE [dbo].[TAdviceCaseStatusChangeRoleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AdviceCaseStatusChangeId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseStatusChangeRoleAudit_ConcurrencyId] DEFAULT ((1)),
[AdviceCaseStatusChangeRoleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdviceCaseStatusChangeRoleAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdviceCaseStatusChangeRoleAudit] ADD CONSTRAINT [PK_TAdviceCaseStatusChangeRoleAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAdviceCaseStatusChangeRoleAudit_AdviceCaseStatusChangeRoleId_ConcurrencyId] ON [dbo].[TAdviceCaseStatusChangeRoleAudit] ([AdviceCaseStatusChangeRoleId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
