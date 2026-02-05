CREATE TABLE [dbo].[TFinancialPlanningImageAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ImageData] [varbinary] (max) NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningImageAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FinancialPlanningImageId] [int] NOT NULL,
[FinancialPlanningOutputId] [int] NULL,
[FinancialPlanningImageTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningImageAudit_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningImageAudit] ADD CONSTRAINT [PK_TFinancialPlanningImageAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
