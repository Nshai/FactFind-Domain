CREATE TABLE [dbo].[TLeadStatusToRoleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LeadStatusToRoleId] [int] NOT NULL,
[LeadStatusId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLeadStatusToRoleAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TLeadStatusToRoleAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLeadStatusToRoleAudit] ADD CONSTRAINT [PK_TLeadStatusToRoleAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
