CREATE TABLE [dbo].[TPropositionToOpportunityTypeLinkAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PropositionToOpportunityTypeLinkId] [int] NOT NULL,
[PropositionTypeId] [int] NULL,
[OpportunityTypeId] [int] NULL,
[ConcurrencyId] [int] null,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPropositionToOpportunityTypeLinkAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPropositionToOpportunityTypeLinkAudit] ADD CONSTRAINT [PK_TPropositionToOpportunityTypeLinkAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPropositionToOpportunityTypeLinkAudit_PropositionToOpportunityTypeLinkId_ConcurrencyId] ON [dbo].[TPropositionToOpportunityTypeLinkAudit] ([PropositionToOpportunityTypeLinkId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO


