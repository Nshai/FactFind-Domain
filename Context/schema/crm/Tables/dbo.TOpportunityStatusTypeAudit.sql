CREATE TABLE [dbo].[TOpportunityStatusTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (32) COLLATE Latin1_General_CI_AS NULL,
[Archive] [bit] NULL CONSTRAINT [DF_TOpportunityStatusTypeAudit_Archive] DEFAULT ((0)),
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TOpportunityStatusTypeAudit_ConcurrencyId] DEFAULT ((1)),
[OpportunityStatusTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOpportunityStatusTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOpportunityStatusTypeAudit] ADD CONSTRAINT [PK_TOpportunityStatusTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TOpportunityStatusTypeAudit_OpportunityStatusTypeId_ConcurrencyId] ON [dbo].[TOpportunityStatusTypeAudit] ([OpportunityStatusTypeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
