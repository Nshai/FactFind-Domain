CREATE TABLE [dbo].[TOpportunityTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[OpportunityTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ArchiveFG] [bit] NOT NULL,
[SystemFG] [bit] NOT NULL CONSTRAINT [DF_TOpportunityTypeAudit_SystemFG] DEFAULT ((0)),
[InvestmentDefault] [bit] NOT NULL CONSTRAINT [DF_TOpportunityTypeAudit_InvestmentDefault] DEFAULT ((0)),
[RetirementDefault] [bit] NULL CONSTRAINT [DF_TOpportunityTypeAudit_RetirementDefault] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL,
[OpportunityTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOpportunityTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ObjectiveType] [varchar](20) NULL
)
GO
ALTER TABLE [dbo].[TOpportunityTypeAudit] ADD CONSTRAINT [PK_TOpportunityTypeAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=75)
GO
