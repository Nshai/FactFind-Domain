CREATE TABLE [dbo].[TCategoryPlanTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PlanCategoryId] [int] NOT NULL,
[RefPlanTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCategoryP_ConcurrencyId_1__56] DEFAULT ((1)),
[CategoryPlanTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCategoryP_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCategoryPlanTypeAudit] ADD CONSTRAINT [PK_TCategoryPlanTypeAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TCategoryPlanTypeAudit_CategoryPlanTypeId_ConcurrencyId] ON [dbo].[TCategoryPlanTypeAudit] ([CategoryPlanTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
