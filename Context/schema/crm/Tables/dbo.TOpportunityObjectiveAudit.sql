CREATE TABLE [dbo].[TOpportunityObjectiveAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[OpportunityId] [int] NULL,
[ObjectiveId] [int] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TOpportunityObjectiveAudit_ConcurrencyId] DEFAULT ((1)),
[OpportunityObjectiveId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOpportunityObjectiveAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOpportunityObjectiveAudit] ADD CONSTRAINT [PK_TOpportunityObjectiveAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TOpportunityObjectiveAudit_OpportunityObjectiveId_ConcurrencyId] ON [dbo].[TOpportunityObjectiveAudit] ([OpportunityObjectiveId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
