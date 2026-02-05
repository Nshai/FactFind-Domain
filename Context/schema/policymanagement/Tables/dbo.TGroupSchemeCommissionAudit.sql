CREATE TABLE [dbo].[TGroupSchemeCommissionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[GroupSchemeId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[PolicyExpectedCommissionId] [int] NOT NULL,
[SchemeCommissionRate] [decimal] (10, 2) NULL,
[SchemeCommissionType] [tinyint] NULL,
[IsCalculateCommissionDue] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGroupSchemeCommissionAudit_ConcurrencyId] DEFAULT ((1)),
[GroupSchemeCommissionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TGroupSchemeCommissionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TGroupSchemeCommissionAudit] ADD CONSTRAINT [PK_TGroupSchemeCommissionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TGroupSchemeCommissionAudit_GroupSchemeCommissionId_ConcurrencyId] ON [dbo].[TGroupSchemeCommissionAudit] ([GroupSchemeCommissionId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
