CREATE TABLE [dbo].[TOpportunityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[OpportunityTypeId] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[Amount] [money] NULL,
[Probability] [decimal] (5, 2) NULL,
[PractitionerId] [int] NULL,
[IntroducerId] [int] NULL,
[IsClosed] [bit] NOT NULL,
[ClosedDate] [datetime] NULL,
[CampaignDataId] [int] NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[SequentialRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AdviserAssignedByUserId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOpportunityAudit_ConcurrencyId] DEFAULT ((1)),
[ClientAssetValue] [decimal] (18, 2) NULL,
[PropositionTypeId] [int] Null,
[TargetClosedDate] [datetime] NULL,
[OpportunityId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOpportunityAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[OpportunityMigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AmountOngoing] [money] NULL
)
GO
ALTER TABLE [dbo].[TOpportunityAudit] ADD CONSTRAINT [PK_TOpportunityAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
