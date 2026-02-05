CREATE TABLE [dbo].[TLifeCycle2RefPlanTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LifeCycleId] [int] NOT NULL,
[RefPlanTypeId] [int] NOT NULL,
[AdviceTypeId] [int] NULL,
[ConcurrencyId] [char] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_TLifeCycle2RefPlanTypeAudit_ConcurrencyId] DEFAULT ((1)),
[LifeCycle2RefPlanTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TLifeCycle2RefPlanTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLifeCycle2RefPlanTypeAudit] ADD CONSTRAINT [PK_TLifeCycle2RefPlanTypeAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
