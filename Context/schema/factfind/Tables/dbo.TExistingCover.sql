CREATE TABLE [dbo].[TExistingCover]
(
	[ExistingCoverId] [int] NOT NULL IDENTITY(1, 1),
	[TenantId] [int] NOT NULL,
	[ProtectionCoverNeedId] [int] NOT NULL CONSTRAINT [FK_TExistingCover_ProtectionCoverNeedId_ProtectionCoverNeedId] FOREIGN KEY REFERENCES TProtectionCoverNeed(ProtectionCoverNeedId),
	[LifeCoverAmount] [money] NULL,
	[CriticalIllnessCoverAmount] [money] NULL,
	[PlanOwnerNames] [nvarchar](255) NULL,
	[CoverDescription] [nvarchar](255) NULL,
	[AssociatedLifeCoverAmount] [money] NULL,
	[AssociatedIllnessCoverAmount] [money] NULL,
	[PolicyBusinessId] [int] NOT NULL,
	[PartyId] [int] NOT NULL,
	[PlanEndDate] [datetime],
	[CoverFrequency] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL
)

GO
ALTER TABLE [dbo].[TExistingCover] ADD CONSTRAINT [PK_TExistingCover] PRIMARY KEY NONCLUSTERED  ([ExistingCoverId])
GO
CREATE NONCLUSTERED INDEX IX_TExistingCover_TenantId_ProtectionCoverNeedId ON [dbo].[TExistingCover] ([TenantId], [ProtectionCoverNeedId])
GO
ALTER TABLE [dbo].[TExistingCover] ADD CONSTRAINT [FK_TExistingCover_TProtectionCoverNeed] FOREIGN KEY ([ProtectionCoverNeedId]) REFERENCES [dbo].[TProtectionCoverNeed] ([ProtectionCoverNeedId])
GO
