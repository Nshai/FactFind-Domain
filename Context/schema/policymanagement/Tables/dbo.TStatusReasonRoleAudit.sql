CREATE TABLE [dbo].[TStatusReasonRoleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RoleId] [int] NOT NULL,
[StatusReasonId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StatusReasonRoleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TStatusReasonRoleAudit] ADD CONSTRAINT [PK_TStatusReasonRoleAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TStatusReasonRoleAudit_StatusReasonRoleId_ConcurrencyId] ON [dbo].[TStatusReasonRoleAudit] ([StatusReasonRoleId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
