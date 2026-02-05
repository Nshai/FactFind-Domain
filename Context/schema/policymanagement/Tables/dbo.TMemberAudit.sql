CREATE TABLE [dbo].[TMemberAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[MemberId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMemberAudit] ADD CONSTRAINT [PK_TMemberAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
