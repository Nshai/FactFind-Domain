CREATE TABLE [dbo].[TPlanCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PlanCategoryName] [varchar] (255) NOT NULL,
[RetireFg] [bit] NOT NULL CONSTRAINT [DF_TPlanCategoryAudit_RetireFg] DEFAULT ((0)),
[IndigoClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPlanCategoryAudit_ConcurrencyId] DEFAULT ((1)),
[PlanCategoryId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPlanCategoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TPlanCategoryAudit] ADD CONSTRAINT [PK_TPlanCategoryAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_Audit_TPlanCategoryAudit_PlanCategoryId_ConcurrencyId] ON [dbo].[TPlanCategoryAudit] ([PlanCategoryId], [ConcurrencyId])
GO
