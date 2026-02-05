CREATE TABLE [dbo].[TWrapperProvider]
(
[WrapperProviderId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanTypeId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[WrapAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_WrapAllowOtherProvidersFg] DEFAULT ((0)),
[SippAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_SippAllowOtherProvidersFg] DEFAULT ((0)),
[SsasAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_SassAllowOtherProvidersFg] DEFAULT ((0)),
[WrapperOnly] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_WrapperOnly] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TWrapperProvider_ConcurrencyId] DEFAULT ((1)),
[GroupSippAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_GroupSippAllowOtherProvidersFg] DEFAULT ((0)),
[OffshoreBondAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_OffshoreBondAllowOtherProvidersFg] DEFAULT ((0)),
[FamilySippAllowOtherProvidersFg] [bit] NULL CONSTRAINT [DF_TWrapperProvider_FamilySippAllowOtherProvidersFg] DEFAULT ((0)),
[QropsAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_QropsAllowOtherProvidersFg] DEFAULT ((0)),
[SuperAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_SuperAllowOtherProvidersFg] DEFAULT ((0)),
[JuniorSIPPAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_JuniorSIPPAllowOtherProvidersFg] DEFAULT ((0)),
[QnupsAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_QnupsAllowOtherProvidersFg] DEFAULT ((0)),
[WrapInvestmentAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_WrapInvestmentAllowOtherProvidersFg] DEFAULT ((0)),
[PersonalPensionAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_PersonalPensionAllowOtherProvidersFg] DEFAULT ((0)),
[OpenAnnuityAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_OpenAnnuityAllowOtherProvidersFg] DEFAULT ((0)),
[IncomeDrawdownAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_IncomeDrawdownAllowOtherProvidersFg] DEFAULT ((0)),
[PhasedRetirementAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_PhasedRetirementAllowOtherProvidersFg] DEFAULT ((0)),
[RopsAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_RopsAllowOtherProvidersFg] DEFAULT ((0)),
[InvestmentBondAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_InvestmentBondAllowOtherProvidersFg] DEFAULT ((0)),
[PensionAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_PensionAllowOtherProvidersFg] DEFAULT ((0)),
[SuperWrapAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_SuperWrapAllowOtherProvidersFg] DEFAULT ((0)),
[SelfManagedSuperFundAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProvider_SelfManagedSuperFundAllowOtherProvidersFg] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TWrapperProvider] ADD CONSTRAINT [PK_TWrapperProvider] PRIMARY KEY CLUSTERED  ([WrapperProviderId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IX_TWrapperProvider_RefPlanTypeId] ON [dbo].[TWrapperProvider] ([RefPlanTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TWrapperProvider_RefProdProviderId] ON [dbo].[TWrapperProvider] ([RefProdProviderId])
GO
ALTER TABLE [dbo].[TWrapperProvider] ADD CONSTRAINT [FK_TWrapperProvider_TRefPlanType] FOREIGN KEY ([RefPlanTypeId]) REFERENCES [dbo].[TRefPlanType] ([RefPlanTypeId])
GO
ALTER TABLE [dbo].[TWrapperProvider] ADD CONSTRAINT [FK_TWrapperProvider_TRefProdProvider] FOREIGN KEY ([RefProdProviderId]) REFERENCES [dbo].[TRefProdProvider] ([RefProdProviderId])
GO
