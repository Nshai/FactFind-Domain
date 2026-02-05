CREATE TABLE [dbo].[TRefFactFindCategoryPlanTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Category] [varchar] (24) COLLATE Latin1_General_CI_AS NULL,
[RefFactFindCategoryId] [int] NULL,
[RefPlanTypeId] [int] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TRefFactFindCategoryPlanTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefFactFindCategoryPlanTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefFactFindCategoryPlanTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefFactFindCategoryPlanTypeAudit] ADD CONSTRAINT [PK_TRefFactFindCategoryPlanTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
