CREATE TABLE [dbo].[TOpportunityFeeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[OpportunityId] [int] NULL,
[FeeId] [int] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TOpportunityFeeAudit_ConcurrencyId] DEFAULT ((1)),
[OpportunityFeeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOpportunityFeeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOpportunityFeeAudit] ADD CONSTRAINT [PK_TOpportunityFeeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TOpportunityFeeAudit_OpportunityFeeId_ConcurrencyId] ON [dbo].[TOpportunityFeeAudit] ([OpportunityFeeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
