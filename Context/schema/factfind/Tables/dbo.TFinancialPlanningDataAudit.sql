CREATE TABLE [dbo].[TFinancialPlanningDataAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[DataKey] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[DataValue] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[FinancialPlanningDataId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningDataAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FinancialPlanningOutputId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningDataAudit_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningDataAudit] ADD CONSTRAINT [PK_TFinancialPlanningDataAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
