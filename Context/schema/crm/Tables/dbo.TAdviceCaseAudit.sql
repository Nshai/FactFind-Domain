CREATE TABLE [dbo].[TAdviceCaseAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[PractitionerId] [int] NOT NULL,
[StatusId] [int] NOT NULL,
[StartDate] [datetime] NOT NULL,
[CaseName] [varchar] (255) NOT NULL,
[CaseRef] [varchar] (50) NULL,
[BinderId] [int] NULL,
[BinderDescription] [varchar] (255) NULL,
[BinderOwnerId] [int] NULL,
[SequentialRef] [varchar] (50) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseAudit_ConcurrencyId] DEFAULT ((1)),
[AdviseCategoryId] [int] NULL,
[AdviceCaseId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdviceCaseAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
[Owner2PartyId] [int] NULL,
[IsJoint] [bit] NULL CONSTRAINT [DF_TAdviceCaseAudit_IsJoint] DEFAULT ((0)),
[ReopenDate] [datetime] NULL,
[StatusChangedOn] [datetime] NULL,
[Owner1Vulnerability] [varchar] (5) NULL,
[Owner2Vulnerability] [varchar] (5) NULL,
[Owner1VulnerabilityNotes] [varchar] (max) NULL,
[Owner2VulnerabilityNotes] [varchar] (max) NULL,
[ServicingAdminUserId] [int] NULL,
[ParaplannerUserId] [int] NULL,
[RecommendationId] [int] NULL,
[Owner1VulnerabilityId] [int] NULL,
[Owner2VulnerabilityId] [int] NULL,
[HasRisk] [bit] NULL,
[ComplianceCompletedBy] [varchar] (50) NULL,
[PropertiesJson] [nvarchar] (max)  NULL,
)
GO
ALTER TABLE [dbo].[TAdviceCaseAudit] ADD CONSTRAINT [PK_TAdviceCaseAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE CLUSTERED INDEX [CLX_TAdviceCaseAudit_AdviceCaseId] ON [dbo].[TAdviceCaseAudit] ([AdviceCaseId])
GO