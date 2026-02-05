CREATE TABLE [dbo].[TAdviceCaseOpportunityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AdviceCaseId] [int] NOT NULL,
[OpportunityId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseOpportunityAudit_ConcurrencyId] DEFAULT ((1)),
[AdviceCaseOpportunityId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdviceCaseOpportunityAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdviceCaseOpportunityAudit] ADD CONSTRAINT [PK_TAdviceCaseOpportunityAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAdviceCaseOpportunityAudit_AdviceCaseOpportunityId_ConcurrencyId] ON [dbo].[TAdviceCaseOpportunityAudit] ([AdviceCaseOpportunityId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
