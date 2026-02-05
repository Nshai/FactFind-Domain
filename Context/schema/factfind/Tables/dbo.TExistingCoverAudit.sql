CREATE TABLE [dbo].[TExistingCoverAudit]
(
	[AuditId] [int] NOT NULL IDENTITY(1, 1),
	[TenantId] [int] NOT NULL,
	[ProtectionCoverNeedId] [int] NOT NULL,
	[LifeCoverAmount] [money] NULL,
	[CriticalIllnessCoverAmount] [money] NULL,
	[AssociatedLifeCoverAmount] [money] NULL,
	[PlanOwnerNames] [nvarchar](255) NULL,
	[CoverDescription] [nvarchar](255) NULL,
	[AssociatedIllnessCoverAmount] [money] NULL,
	[PolicyBusinessId] [int] NOT NULL,
	[PartyId] [int] NOT NULL,
	[PlanEndDate] [datetime],
	[CoverFrequency] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[ExistingCoverId] [int] NOT NULL,
	[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_TExistingCoverAudit_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TExistingCoverAudit] ADD CONSTRAINT [PK_TExistingCoverAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TExistingCoverAudit_StampDateTime_ExistingCoverId] ON [dbo].[TExistingCoverAudit] (StampDateTime, ExistingCoverId) WITH (FILLFACTOR=90)
go