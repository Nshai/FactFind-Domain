CREATE TABLE [dbo].[TOpportunityCustomerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[OpportunityId] [int] NOT NULL,
[PartyId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TOpportunityCustomerAudit_ConcurrencyId] DEFAULT ((1)),
[OpportunityCustomerId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOpportunityCustomerAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOpportunityCustomerAudit] ADD CONSTRAINT [PK_TOpportunityCustomerAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IX_TOpportunityCustomerAudit] ON [dbo].[TOpportunityCustomerAudit] ([OpportunityId])
GO
