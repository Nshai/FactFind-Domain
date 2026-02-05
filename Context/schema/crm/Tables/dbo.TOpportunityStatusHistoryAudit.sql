CREATE TABLE [dbo].[TOpportunityStatusHistoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[OpportunityId] [int] NOT NULL,
[OpportunityStatusId] [int] NOT NULL,
[DateOfChange] [datetime] NOT NULL,
[ChangedByUserId] [int] NOT NULL,
[CurrentStatusFG] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[OpportunityStatusHistoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOpportunityStatusHistoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOpportunityStatusHistoryAudit] ADD CONSTRAINT [PK_TOpportunityStatusHistoryAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
