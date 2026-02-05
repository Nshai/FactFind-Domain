CREATE TABLE [dbo].[TRefPlanningTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PlanningType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanningTypeAudit_ConcurrencyId] DEFAULT ((0)),
[RefPlanningTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefPlanningTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefPlanningTypeAudit] ADD CONSTRAINT [PK_TRefPlanningTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefPlanningTypeAudit_RefPlanningTypeId_ConcurrencyId] ON [dbo].[TRefPlanningTypeAudit] ([RefPlanningTypeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
