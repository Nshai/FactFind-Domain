
CREATE TABLE [dbo].[TProtectionCoverNeedPlan]
(
	[ProtectionCoverNeedPlanId] [int] NOT NULL IDENTITY(1, 1),
	[TenantId] [int] NOT NULL,
	[PlanId] [int] NOT NULL,
	[PartyId] [int] NOT NULL,
	[LifeCoverAmount] [money] NULL,
	[CriticalIllnessCoverAmount] [money] NULL,
	[PlanOwnerNames] [nvarchar](255) NULL,
	[CoverDescription] [nvarchar](255) NULL,
	[PlanEndDate] [datetime],
	[NeedAnalysisType] [nvarchar](50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_TProtectionCoverNeedPlan_NeedAnalysisType] DEFAULT 'SinglePayout',
	[CoverFrequency] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL
)

GO
ALTER TABLE [dbo].[TProtectionCoverNeedPlan] ADD CONSTRAINT [PK_TProtectionCoverNeedPlan] PRIMARY KEY NONCLUSTERED  ([ProtectionCoverNeedPlanId])
GO
CREATE NONCLUSTERED INDEX IX_TProtectionCoverNeedPlan_TenantId_PartyId_JointPartyId ON [dbo].[TProtectionCoverNeedPlan] ([TenantId], [PartyId], [JointPartyId])
GO

