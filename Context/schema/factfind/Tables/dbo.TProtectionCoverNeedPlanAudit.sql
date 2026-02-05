
CREATE TABLE [dbo].[TProtectionCoverNeedPlanAudit]
(
	[AuditId] [int] NOT NULL IDENTITY(1, 1),
	[TenantId] [int] NOT NULL,
	[PlanId] [int] NOT NULL,
	[PartyId] [int] NOT NULL,
	[LifeCoverAmount] [money] NULL,
	[CriticalIllnessCoverAmount] [money] NULL,
	[PlanOwnerNames] [nvarchar](255) NULL,
	[CoverDescription] [nvarchar](255) NULL,
	[PlanEndDate] [datetime],
	[NeedAnalysisType] [nvarchar](50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_TProtectionCoverNeedPlanAudit_NeedAnalysisType] DEFAULT 'SinglePayout',
	[CoverFrequency] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[ProtectionCoverNeedPlanId] [int] NOT NULL,
	[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProtectionCoverNeedPlanAudit_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)

GO
ALTER TABLE [dbo].[TProtectionCoverNeedPlanAudit] ADD CONSTRAINT [PK_TProtectionCoverNeedPlanAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TProtectionCoverNeedPlanAudit_StampDateTime_ProtectionCoverNeedPlanId] ON [dbo].[TProtectionCoverNeedPlanAudit] ([StampDateTime], [ProtectionCoverNeedPlanId]) WITH (FILLFACTOR=90)
go

