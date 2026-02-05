CREATE TABLE [dbo].[TWrapperProviderAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanTypeId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[WrapAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProviderAudit_WrapAllowOtherProvidersFg] DEFAULT ((0)),
[SippAllowOtherProvidersFg] [bit] NULL CONSTRAINT [DF_TWrapperProviderAudit_SippAllowOtherProvidersFg] DEFAULT ((0)),
[SsasAllowOtherProvidersFg] [bit] NULL,
[WrapperOnly] [bit] NULL CONSTRAINT [DF_TWrapperProviderAudit_WrapperOnly] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TWrapperProviderAudit_ConcurrencyId] DEFAULT ((1)),
[WrapperProviderId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TWrapperProviderAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[GroupSippAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProviderAudit_GroupSippAllowOtherProvidersFg] DEFAULT ((0)),
[OffshoreBondAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProviderAudit_OffshoreBondAllowOtherProvidersFg] DEFAULT ((0)),
[FamilySippAllowOtherProvidersFg] [bit] NULL CONSTRAINT [DF_TWrapperProviderAudit_FamilySippAllowOtherProvidersFg] DEFAULT ((0)),
[QropsAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProviderAudit_QropsAllowOtherProvidersFg] DEFAULT ((0)),
[SuperAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProviderAudit_SuperAllowOtherProvidersFg] DEFAULT ((0)),
[JuniorSIPPAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProviderAudit_JuniorSIPPAllowOtherProvidersFg] DEFAULT ((0)),
[QnupsAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProviderAudit_QnupsAllowOtherProvidersFg] DEFAULT ((0)),
[WrapInvestmentAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProviderAudit_WrapInvestmentAllowOtherProvidersFg] DEFAULT ((0)),
[PersonalPensionAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProviderAudit_PersonalPensionAllowOtherProvidersFg] DEFAULT ((0)),
[OpenAnnuityAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProviderAudit_OpenAnnuityAllowOtherProvidersFg] DEFAULT ((0)),
[IncomeDrawdownAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProviderAudit_IncomeDrawdownAllowOtherProvidersFg] DEFAULT ((0)),
[PhasedRetirementAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProviderAudit_PhasedRetirementAllowOtherProvidersFg] DEFAULT ((0)),
[RopsAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProviderAudit_RopsAllowOtherProvidersFg] DEFAULT ((0)),
[InvestmentBondAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProviderAudit_InvestmentBondAllowOtherProvidersFg] DEFAULT ((0)),
[PensionAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProviderAudit_PensionAllowOtherProvidersFg] DEFAULT ((0)),
[SuperWrapAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProviderAudit_SuperWrapAllowOtherProvidersFg] DEFAULT ((0)),
[SelfManagedSuperFundAllowOtherProvidersFg] [bit] NOT NULL CONSTRAINT [DF_TWrapperProviderAudit_SelfManagedSuperFundAllowOtherProvidersFg] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TWrapperProviderAudit] ADD CONSTRAINT [PK_TWrapperProviderAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TWrapperProviderAudit_WrapperProviderId_ConcurrencyId] ON [dbo].[TWrapperProviderAudit] ([WrapperProviderId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
