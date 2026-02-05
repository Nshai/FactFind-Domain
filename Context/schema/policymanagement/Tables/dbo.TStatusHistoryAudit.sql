CREATE TABLE [dbo].[TStatusHistoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PolicyBusinessId] [int] NOT NULL,
[StatusId] [int] NOT NULL,
[StatusReasonId] [int] NULL,
[ChangedToDate] [datetime] NOT NULL,
[ChangedByUserId] [int] NOT NULL,
[DateOfChange] [datetime] NULL,
[LifeCycleStepFG] [bit] NOT NULL CONSTRAINT [DF_TStatusHis_LifeCycleStepFG] DEFAULT ((0)),
[CurrentStatusFG] [bit] NOT NULL CONSTRAINT [DF_TStatusHistoryAudit_CurrentStatusFG] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TStatusHis_ConcurrencyId] DEFAULT ((1)),
[StatusHistoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TStatusHis_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
PlanMigrationRef varchar(255)
)
GO
ALTER TABLE [dbo].[TStatusHistoryAudit] ADD CONSTRAINT [PK_TStatusHistoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) 
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TStatusHistoryAudit_StatusHistoryId_ConcurrencyId] ON [dbo].[TStatusHistoryAudit] ([StatusHistoryId], [ConcurrencyId]) 
GO
CREATE NONCLUSTERED INDEX [IDX_TStatusHistoryAudit_StampDateTime] ON [dbo].[TStatusHistoryAudit] ([StampDateTime]) INCLUDE ([StatusHistoryId],[PolicyBusinessId],[StampAction])
GO
