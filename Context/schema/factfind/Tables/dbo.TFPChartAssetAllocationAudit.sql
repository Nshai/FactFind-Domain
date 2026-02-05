CREATE TABLE [dbo].[TFPChartAssetAllocationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[AllocationKey] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[AllocationText] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ChartXml] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[FPChartAssetAllocationId] [int] NOT NULL,
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFPChartAssetAllocationAudit] ADD CONSTRAINT [PK_TFPChartAssetAllocationAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
