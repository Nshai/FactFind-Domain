CREATE TABLE [dbo].[TRefPlanType2ProdSubTypeCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NULL,
[PlanCategoryId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanType2ProdSubTypeCategoryAudit_ConcurrencyId] DEFAULT ((1)),
[RefPlanType2ProdSubTypeCategoryId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefPlanType2ProdSubTypeCategoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TRefPlanType2ProdSubTypeCategoryAudit] ADD CONSTRAINT [PK_TRefPlanType2ProdSubTypeCategoryAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefPlanType2ProdSubTypeCategoryAudit_RefPlanType2ProdSubTypeCategoryId_ConcurrencyId] ON [dbo].[TRefPlanType2ProdSubTypeCategoryAudit] ([RefPlanType2ProdSubTypeCategoryId], [ConcurrencyId])
GO
