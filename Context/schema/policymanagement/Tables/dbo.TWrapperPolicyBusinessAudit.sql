CREATE TABLE [dbo].[TWrapperPolicyBusinessAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ParentPolicyBusinessId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TWrapperPolicyBusinessAudit_ConcurrencyId] DEFAULT ((1)),
[WrapperPolicyBusinessId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TWrapperPolicyBusinessAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TWrapperPolicyBusinessAudit] ADD CONSTRAINT [PK_TWrapperPolicyBusinessAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TWrapperPolicyBusinessAudit_WrapperPolicyBusinessId_ConcurrencyId] ON [dbo].[TWrapperPolicyBusinessAudit] ([WrapperPolicyBusinessId], [ConcurrencyId])
GO
