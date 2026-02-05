CREATE TABLE [dbo].[TAdviceareas]
(
[AdviceareasId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[DateOfFirstInterview] [datetime] NULL,
[AnybodyElsePresent] [bit] NULL,
[AnybodyElsePresentDetails] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[UnprotectedLiabilities] [bit] NULL,
[SufferInIllness] [bit] NULL,
[ProtectionAdvice] [bit] NULL,
[HasPensionProvision] [bit] NULL,
[PensionProvisionProvidesRetirementIncome] [bit] NULL,
[RetirementAdvice] [bit] NULL,
[HasRegularSavings] [bit] NULL,
[HasCashDeposits] [bit] NULL,
[InvestmentAdvice] [bit] NULL,
[HasValidWill] [bit] NULL,
[IsWillUptoDate] [bit] NULL,
[EstateAdvice] [bit] NULL,
[AdviceOption] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[PA] [bit] NULL,
[RPA] [bit] NULL,
[SIA] [bit] NULL,
[ProtectAgainstDeath] [bit] NULL,
[ProtectAgainstIllness] [bit] NULL,
[ProtectEarnings] [bit] NULL,
[ProvideRetirementIncome] [bit] NULL,
[ProtectMortgage] [bit] NULL,
[PMI] [bit] NULL,
[InvestingCapital] [bit] NULL,
[RegSavings] [bit] NULL,
[InheritanceTaxPlanning] [bit] NULL,
[SchoolFeesPlanning] [bit] NULL,
[LongTermCare] [bit] NULL,
[PurchasingProperty] [bit] NULL,
[RemortgagingProperty] [bit] NULL,
[RaisingCapital] [bit] NULL,
[MortgageAdvice] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TAdviceAreas__ConcurrencyId] DEFAULT ((1)),
[RefInterviewTypeId] [int] NULL,
[ClientsPresent] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[HasBeenAdvisedToMakeWill] [bit] NULL,
[CreatedOn] [datetime] NULL CONSTRAINT [DF__TAdvicear__Creat__E2E3D9B] DEFAULT (getdate()),
[CreatedByUserId] [int] NULL,
[UpdatedOn] [datetime] NULL CONSTRAINT [DF__TAdvicear__Updat__1E0146BC] DEFAULT (getdate()),
[UpdatedByUserId] [int] NULL
)
GO
ALTER TABLE [dbo].[TAdviceareas] ADD CONSTRAINT [PK_TAdviceareas] PRIMARY KEY NONCLUSTERED  ([AdviceareasId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAdviceareas_CRMContactId] ON [dbo].[TAdviceareas] ([CRMContactId])
GO
CREATE CLUSTERED INDEX [IX_TAdviceareas_CRMContactId] ON [dbo].[TAdviceareas] ([CRMContactId])
GO
