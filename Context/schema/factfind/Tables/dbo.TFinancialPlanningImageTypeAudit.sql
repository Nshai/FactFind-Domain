CREATE TABLE [dbo].[TFinancialPlanningImageTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ImageTypeDisplayName] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[ImageTypeName] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningImageTypeAudit_ConcurrencyId] DEFAULT ((1)),
[FinancialPlanningImageTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningImageTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningImageTypeAudit] ADD CONSTRAINT [PK_TFinancialPlanningImageTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
