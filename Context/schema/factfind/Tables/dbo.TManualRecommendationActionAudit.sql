CREATE TABLE [dbo].[TManualRecommendationActionAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[ManualRecommendationActionId] [int] NOT NULL,
	[ManualRecommendationId] [int] NOT NULL,
	[ActionType] [int] NOT NULL,
	[PolicyBusinessId] [int] NULL,
	[StatusReasonId] [int] NULL,
	[RefProdProviderId] [int] NULL,
	[RefPlanType2ProdSubTypeId] [int] NULL,
	[DetailsXml] [xml] NULL,
	[RefRecommendationStatusId] [int] NULL,
	[ModificationDate] [datetime] NOT NULL,
	[StampAction] [char](1) NOT NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar](255) NULL,
	[PremiumAmount] [money] NULL,
	[PremiumStartDate] [datetime] NULL,
	[PremiumFrequencyId] [int] NULL,
	[DeferReasonId] [int] NULL,
	[DeferReasonNote] [ntext] NULL,
	[RejectReasonId]   	[int] NULL,
	[RejectReasonNote]	[ntext]	NULL,
	[RegularSelfContribution] [money] NULL,
	[RegularEmployerContribution] [money] NULL,
	[LumpSumContribution] [money] NULL,
	[WithdrawalAmount] [money] NULL,
	[RegularSelfContributionFrequencyId] [int] NULL,
	[RegularEmployerContributionFrequencyId] [int] NULL,
	[RefWithdrawalTypeId] [int] NULL,
	[RefWithdrawalFrequencyId] [int] NULL,
	[IsRegularSelfContributionIncreased] [bit] NULL,
	[IsRegularEmployerContributionIncreased] [bit] NULL,
	[IsWithdrawalIncreased] [bit] NULL,
	[IsOffPanel] [bit] NULL,
	[PlanTypeThirdPartyDescription] [varchar](255) NULL,
	[TopupParentPolicyBusinessId] [int] NULL,
	[SellingAdviserPartyId] [int] NULL

 CONSTRAINT [PK_TManualRecommendationActionAudit] PRIMARY KEY NONCLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[TManualRecommendationActionAudit] ADD  CONSTRAINT [DF_TManualRecommendationActionAudit_StampDateTime]  DEFAULT (getdate()) FOR [StampDateTime]
GO


