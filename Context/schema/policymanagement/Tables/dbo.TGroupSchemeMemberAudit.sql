CREATE TABLE [dbo].[TGroupSchemeMemberAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[GroupSchemeId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[GroupSchemeCategoryId] [int] NULL,
[PolicyBusinessId] [int] NULL,
[JoiningDate] [datetime] NULL,
[LeavingDate] [datetime] NULL,
[IsLeaver] [bit] NOT NULL CONSTRAINT [DF_TGroupSchemeMemberAudit_IsLeaver] DEFAULT ((0)),
[NominatedBeneficiary] [varchar] (255) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGroupSchemeMemberAudit_ConcurrencyId] DEFAULT ((1)),
[GroupSchemeMemberId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TGroupSchemeMemberAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TGroupSchemeMemberAudit] ADD CONSTRAINT [PK_TGroupSchemeMemberAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TGroupSchemeMemberAudit_GroupSchemeMemberId_ConcurrencyId] ON [dbo].[TGroupSchemeMemberAudit] ([GroupSchemeMemberId], [ConcurrencyId])
GO
