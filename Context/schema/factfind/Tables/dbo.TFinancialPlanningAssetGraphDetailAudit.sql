CREATE TABLE [dbo].[TFinancialPlanningAssetGraphDetailAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[Data] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NULL,
[FinancialPlanningAssetGraphDetailId] [int] NULL,
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningAssetGraphDetailAudit] ADD CONSTRAINT [PK_TFinancialPlanningAssetGraphAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
