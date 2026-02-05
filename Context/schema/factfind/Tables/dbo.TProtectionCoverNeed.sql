
CREATE TABLE [dbo].[TProtectionCoverNeed]
(
	[ProtectionCoverNeedId] [int] NOT NULL IDENTITY(1, 1),
	[TenantId] [int] NOT NULL,
	[PartyId] [int] NOT NULL,
	[JointPartyId] [int] NULL,
	[Frequency] [nvarchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[Term] [int] NULL,
	[TermType] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Notes] [nvarchar](4000) COLLATE Latin1_General_CI_AS NULL,
	[NeedType] [nvarchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[CoverAmount] [money],
	[AssociatedCoverSummary] [nvarchar](255) COLLATE Latin1_General_CI_AS NULL,
	[SystemGenerated] [bit] CONSTRAINT [DF_TProtectionCoverNeed_SystemGenerated] Default(0)
)

GO
ALTER TABLE [dbo].[TProtectionCoverNeed] ADD CONSTRAINT [PK_TProtectionCoverNeed] PRIMARY KEY CLUSTERED  ([ProtectionCoverNeedId])
GO
CREATE NONCLUSTERED INDEX IX_TProtectionCoverNeed_TenantId_PartyId_JointPartyId ON [dbo].[TProtectionCoverNeed] ([TenantId], [PartyId], [JointPartyId])
GO


