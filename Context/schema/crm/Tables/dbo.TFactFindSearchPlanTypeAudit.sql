CREATE TABLE [dbo].[TFactFindSearchPlanTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FactFindSearchId] [int] NOT NULL,
[RefPlanTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[FactFindSearchPlanTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFactFindSearchPlanTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFactFindSearchPlanTypeAudit] ADD CONSTRAINT [PK_TFactFindSearchPlanTypeAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TFactFindSearchPlanTypeAudit_FactFindSearchPlanTypeId_ConcurrencyId] ON [dbo].[TFactFindSearchPlanTypeAudit] ([FactFindSearchPlanTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
