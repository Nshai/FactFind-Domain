CREATE TABLE [dbo].[TAdviceCase]
(
[AdviceCaseId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[PractitionerId] [int] NOT NULL,
[StatusId] [int] NOT NULL,
[StartDate] [datetime] NOT NULL,
[CaseName] [varchar] (255)  NOT NULL,
[CaseRef] [varchar] (50)  NULL,
[BinderId] [int] NULL,
[BinderDescription] [varchar] (255) NULL,
[BinderOwnerId] [int] NULL,
[SequentialRefLegacy] [varchar] (50)  NULL,
[SequentialRef]  AS (case when [SequentialRefLegacy] IS NULL then 'IOA'+right(replicate('0',(8))+ CONVERT([varchar],[AdviceCaseId]),(8))  else [SequentialRefLegacy] end),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCase_ConcurrencyId] DEFAULT ((1)),
[AdviseCategoryId] [int] NULL,
[Owner2PartyId] [int] NULL,
[IsJoint] [bit] NULL CONSTRAINT [DF_TAdviceCase_IsJoint] DEFAULT ((0)),
[ReopenDate] [datetime] NULL,
[StatusChangedOn] [datetime] NULL,
[Owner1Vulnerability] [varchar] (5)  NULL,
[Owner2Vulnerability] [varchar] (5)  NULL,
[Owner1VulnerabilityNotes] [varchar] (max)  NULL,
[Owner2VulnerabilityNotes] [varchar] (max)  NULL,
[ServicingAdminUserId] [int] NULL,
[ParaplannerUserId] [int] NULL,
[RecommendationId] [int] NULL, 
[Owner1VulnerabilityId] [int] NULL,
[Owner2VulnerabilityId] [int] NULL,
[MigrationReference] [varchar] (255) NULL,
[HasRisk] [bit] NULL,
[ComplianceCompletedBy] [varchar] (50) NULL,
[PropertiesJson] [nvarchar] (max)  NULL,
[Client1AtrId] [int] NULL,
[Client1RiskProfileId] [int] NULL,
[Client1RiskProfileName] [varchar] (250) NULL,
[Client2AtrId] [int] NULL,
[Client2RiskProfileId] [int] NULL,
[Client2RiskProfileName] [varchar] (250) NULL,
[Client1InvestmentPreferenceId] [int] NULL,
[Client2InvestmentPreferenceId] [int] NULL
)
GO
ALTER TABLE [dbo].[TAdviceCase] ADD CONSTRAINT [PK_TAdviceCase] PRIMARY KEY CLUSTERED  ([AdviceCaseId])
GO
CREATE NONCLUSTERED INDEX [TAdviceCase_Index_AdviseCategoryId] ON [dbo].[TAdviceCase] ([AdviseCategoryId])
GO
CREATE NONCLUSTERED INDEX [IX_TAdviceCase_CRMContactID] ON [dbo].[TAdviceCase] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IX_TAdviseCase_Owner2PartyId] ON [dbo].[TAdviceCase] ([Owner2PartyId])
GO
CREATE NONCLUSTERED INDEX [IX_TAdviceCase_PractitionerId] ON [dbo].[TAdviceCase] ([PractitionerId])
GO
CREATE NONCLUSTERED INDEX IX_TAdviceCase_BinderId ON [dbo].[TAdviceCase] ([BinderId]) INCLUDE ([AdviceCaseId],[PractitionerId])
GO