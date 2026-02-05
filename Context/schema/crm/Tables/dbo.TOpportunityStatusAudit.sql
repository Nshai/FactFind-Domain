CREATE TABLE [dbo].[TOpportunityStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[OpportunityStatusName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[InitialStatusFG] [bit] NOT NULL,
[ArchiveFG] [bit] NOT NULL,
[AutoCloseOpportunityFg] [bit] NOT NULL CONSTRAINT [DF_TOpportunityStatusAudit_AutoCloseOpportunityFg] DEFAULT ((0)),
[OpportunityStatusTypeId] [int] NOT NULL CONSTRAINT [DF_TOpportunityStatusAudit_OpportunityStatusTypeId] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL,
[OpportunityStatusId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOpportunityStatusAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOpportunityStatusAudit] ADD CONSTRAINT [PK_TOpportunityStatusAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
