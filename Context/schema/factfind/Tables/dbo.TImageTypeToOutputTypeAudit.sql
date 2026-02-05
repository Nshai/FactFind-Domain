CREATE TABLE [dbo].[TImageTypeToOutputTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ImageTypeToOutputTypeId] [int] NOT NULL,
[FinancialPlanningImageTypeId] [int] NOT NULL,
[FinancialPlanningOutputTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TImageTypeToOutputTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TImageTypeToOutputTypeAudit] ADD CONSTRAINT [PK_TImageTypeToOutputTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
