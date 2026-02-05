CREATE TABLE [dbo].[TPolicyBusiness]
(
[PolicyBusinessId] [int] NOT NULL IDENTITY(1, 1),
[PolicyDetailId] [int] NOT NULL,
[PolicyNumber] [varchar] (50) NULL,
[PractitionerId] [int] NOT NULL,
[ReplaceNotes] [varchar] (8000) NULL,
[TnCCoachId] [int] NULL,
[AdviceTypeId] [int] NOT NULL,
[BestAdvicePanelUsedFG] [bit] NOT NULL CONSTRAINT [DF_TPolicyBusiness_BestAdvicePanelUsedFG] DEFAULT ((0)),
[WaiverDefermentPeriod] [int] NOT NULL CONSTRAINT [DF_TPolicyBusiness_WaiverDefermentPeriod] DEFAULT ((0)),
[IndigoClientId] [int] NOT NULL,
[SwitchFG] [tinyint] NOT NULL CONSTRAINT [DF_TPolicyBusiness_SwitchFG] DEFAULT ((0)),
[TotalRegularPremium] [money] NULL,
[TotalLumpSum] [money] NULL,
[MaturityDate] [datetime] NULL,
[LifeCycleId] [int] NULL,
[PolicyStartDate] [datetime] NULL,
[PremiumType] [varchar] (50) NULL,
[AgencyNumber] [varchar] (50) NULL,
[ProviderAddress] [varchar] (1000) NULL,
[OffPanelFg] [bit] NOT NULL CONSTRAINT [DF_TPolicyBusiness_OffPanelFg] DEFAULT ((0)),
[BaseCurrency] [varchar] (50) NOT NULL,
[ExpectedPaymentDate] [datetime] NULL,
[ProductName] [varchar] (200) NULL,
[InvestmentTypeId] [int] NULL,
[RiskRating] [int] NULL,
[SequentialRefLegacy] [varchar] (50) NULL,
[SequentialRef]  AS (case when [SequentialRefLegacy] IS NULL then 'IOB'+right(replicate('0',(8))+CONVERT([varchar],[PolicyBusinessId]),(8)) else [SequentialRefLegacy] end),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBusiness_ConcurrencyId_1] DEFAULT ((1)),
[IsGuaranteedToProtectOriginalInvestment] [bit] NULL,
[ClientTypeId] [int] NULL,
[PlanMigrationRef] [varchar] (255) NULL,
[UsePriceFeed] [bit] NOT NULL CONSTRAINT [DF_TPolicyBusiness_IsUpdateUnitPrices] DEFAULT ((1)),
[LowMaturityValue] [money] NULL,
[MediumMaturityValue] [money] NULL,
[HighMaturityValue] [money] NULL,
[ProjectionDetails] [varchar] (5000) NULL,
[TopupMasterPolicyBusinessId] [int] NULL,
[ServicingUserId] [int] NULL,
[PropositionTypeId] [int] NULL,
[ParaplannerUserId] [int] NULL,
[GroupId] [int] NULL,
[PerformanceStartDate] [datetime2] NULL,
[PerformanceEndDate] [datetime2] NULL,
[ProviderCode2] [varchar] (50) NULL,
[ProviderCode3] [varchar] (50) NULL
)
GO
ALTER TABLE [dbo].[TPolicyBusiness] ADD CONSTRAINT [PK_TPolicyBusiness] PRIMARY KEY CLUSTERED  ([PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusiness_IndigoClientId] ON [dbo].[TPolicyBusiness] ([IndigoClientId])
GO
CREATE NONCLUSTERED INDEX [IDX_TpolicyBusiness_PolicyDetailId] ON [dbo].[TPolicyBusiness] ([PolicyDetailId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusiness_TopupMasterPolicyBusinessId] ON [dbo].[TPolicyBusiness] ([TopupMasterPolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusiness_PractitionerId] ON [dbo].[TPolicyBusiness] ([PractitionerId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusiness_SequentialRef] ON [dbo].[TPolicyBusiness] ([SequentialRef])
GO
ALTER TABLE [dbo].[TPolicyBusiness] WITH CHECK ADD CONSTRAINT [FK_TAdviceType_AdviceTypeId_AdviceTypeId] FOREIGN KEY ([AdviceTypeId]) REFERENCES [dbo].[TAdviceType] ([AdviceTypeId])
GO
ALTER TABLE [dbo].[TPolicyBusiness] WITH CHECK ADD CONSTRAINT [FK_TPolicyBusiness_LifeCycleId_LifeCycleId] FOREIGN KEY ([LifeCycleId]) REFERENCES [dbo].[TLifeCycle] ([LifeCycleId])
GO
ALTER TABLE [dbo].[TPolicyBusiness] WITH CHECK ADD CONSTRAINT [FK_TPolicyDetail_PolicyDetailId_PolicyDetailId] FOREIGN KEY ([PolicyDetailId]) REFERENCES [dbo].[TPolicyDetail] ([PolicyDetailId])
GO
ALTER TABLE [dbo].[TPolicyBusiness] WITH CHECK ADD CONSTRAINT [FK_TPolicyBusiness_PolicyBusinessId_TopupMasterPolicyBusinessId] FOREIGN KEY ([TopupMasterPolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO