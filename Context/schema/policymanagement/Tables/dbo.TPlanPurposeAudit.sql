CREATE TABLE [dbo].[TPlanPurposeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Descriptor] [varchar] (255) NOT NULL,
[MortgageRelatedfg] [bit] NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPlanPurposeAudit_ConcurrencyId] DEFAULT ((1)),
[PlanPurposeId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPlanPurposeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TPlanPurposeAudit] ADD CONSTRAINT [PK_TPlanPurposeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_Audit_TPlanPurposeAudit_PlanPurposeId_ConcurrencyId] ON [dbo].[TPlanPurposeAudit] ([PlanPurposeId], [ConcurrencyId])
GO
