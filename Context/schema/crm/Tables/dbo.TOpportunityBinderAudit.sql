CREATE TABLE [dbo].[TOpportunityBinderAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[BinderId] [int] NOT NULL,
[OpportunityId] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOpportunityBinderAudit_ConcurrencyId] DEFAULT ((1)),
[OpportunityBinderId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOpportunityBinderAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
)
GO
ALTER TABLE [dbo].[TOpportunityBinderAudit] ADD CONSTRAINT [PK_TOpportunityBinderAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
