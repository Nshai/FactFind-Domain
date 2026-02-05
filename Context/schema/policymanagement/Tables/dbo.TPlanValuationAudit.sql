CREATE TABLE [dbo].[TPlanValuationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PolicyBusinessId] [int] NOT NULL,
[PlanValue] [money] NULL,
[PlanValueDate] [datetime] NULL,
[RefPlanValueTypeId] [int] NULL,
[WhoUpdatedValue] [int] NULL,
[WhoUpdatedDateTime] [datetime] NULL,
[SurrenderTransferValue] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPlanValuationAudit_ConcurrencyId] DEFAULT ((1)),
[PlanValuationId] [bigint] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPlanValuationAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
[ValuationMigrationRef] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TPlanValuationAudit] ADD CONSTRAINT [PK_TPlanValuationAudit_AuditId] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPlanValuationAudit_PlanValuationId] ON [dbo].[TPlanValuationAudit] ([PlanValuationId])
GO
