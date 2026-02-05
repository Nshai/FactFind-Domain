CREATE TABLE [dbo].[TMembershipAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[UserId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[RoleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[MembershipId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TMembershi_StampDateTime_1__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMembershipAudit] ADD CONSTRAINT [PK_TMembershipAudit_2__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TMembershipAudit_MembershipId_ConcurrencyId] ON [dbo].[TMembershipAudit] ([MembershipId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
