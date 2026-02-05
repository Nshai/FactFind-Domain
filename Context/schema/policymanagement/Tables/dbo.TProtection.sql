CREATE TABLE [dbo].[TProtection]
(
[ProtectionId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndigoClientId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[RefPlanSubCategoryId] [int] NOT NULL,
[PremiumLoading] [varchar] (50) NULL,
[Exclusions] [varchar] (2500) NULL,
[RenewalDate] [datetime] NULL,
[AssuredLife1Id] [int] NULL,
[AssuredLife2Id] [int] NULL,
[InTrust] [bit] NULL,
[ToWhom] [varchar] (250) NULL,
[TermValue] [int] NULL,
[InitialEarningsPeriodId] [int] NULL,
[WaitingPeriod] [int] NULL,
[PercentOfPremiumToInvest] [float] NULL,
[TermTypeId] [int] NULL,
[IndexTypeId] [int] NULL,
[LifeCoverSumAssured] [decimal] (18, 6) NULL,
[CriticalIllnessSumAssured] [decimal] (18, 6) NULL,
[PaymentBasisId] [int] NULL,
[CriticalIllnessTermValue] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProtection_ConcurrencyId] DEFAULT ((1)),
[ReviewDate] [datetime] NULL,
[IsForProtectionShortfallCalculation] [bit] NULL,
[PropertyInsuranceType] [varchar] (50) NULL,
[PlanMigrationRef] [varchar] (255) NULL,
[BenefitSummary] [varchar] (5000) NULL,
[ExpensePremiumStructure][varchar] (25) NULL,
[IncomePremiumStructure][varchar] (25) NULL,
[ProtectionPayoutType][varchar] (25) NULL,
[LifeCoverPremiumStructure][varchar] (25) NULL,
[LifeCoverUntilAge][int] NULL,
[CriticalIllnessPremiumStructure][varchar] (25) NULL,
[CriticalIllnessUntilAge][int] NULL,
[SeverityCoverAmount][money] NULL,
[SeverityCoverPremiumStructure][varchar] (25) NULL,
[SeverityCoverTerm][int] NULL,
[SeverityCoverUntilAge][int] NULL,
[PtdCoverAmount][money] NULL,
[PtdCoverPremiumStructure][varchar] (25) NULL,
[PtdCoverTerm][int] NULL,
[PtdCoverUntilAge][int] NULL,
[IncomeCoverTerm] [int] NULL,
[IncomeCoverUntilAge] [int] NULL,
[ExpenseCoverTerm] [int] NULL,
[ExpenseCoverUntilAge] [int] NULL
)
GO
ALTER TABLE [dbo].[TProtection] ADD CONSTRAINT [PK_TProtection] PRIMARY KEY CLUSTERED  ([ProtectionId])
GO
CREATE NONCLUSTERED INDEX [IDX_TProtection_AssuredLife1Id] ON [dbo].[TProtection] ([AssuredLife1Id])
GO
CREATE NONCLUSTERED INDEX [IDX_TProtection_AssuredLife2Id] ON [dbo].[TProtection] ([AssuredLife2Id])
GO
CREATE NONCLUSTERED INDEX [IDX_TProtection_PolicyBusinessId] ON [dbo].[TProtection] ([PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX [IDX_TProtection_PlanMigrationRef] ON [dbo].[TProtection] ([PlanMigrationRef])
GO
CREATE NONCLUSTERED INDEX [IDX_TProtection_IndigoClientId_PolicyBusinessId] ON [dbo].[TProtection] ([IndigoClientId],[PolicyBusinessId]) 
GO