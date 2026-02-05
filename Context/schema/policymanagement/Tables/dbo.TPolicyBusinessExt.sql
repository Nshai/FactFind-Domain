CREATE TABLE [dbo].[TPolicyBusinessExt]
(
[PolicyBusinessExtId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[BandingTemplateId] [int] NOT NULL,
[MigrationRef] [varchar] (255) NULL,
[PortalReference] [varchar] (50) NULL,
[PlatformReference] [varchar] (50) NULL,
[ReportNotes] [varchar] (4000) NULL,
[AnnualCharges] [decimal] (18, 2) NULL,
[WrapperCharge] [decimal] (18, 2) NULL,
[InitialAdviceCharge] [decimal] (18, 2) NULL,
[OngoingAdviceCharge] [decimal] (18, 2) NULL,
[PensionIncrease] [varchar] (50) NULL,
[ReservedValue] [decimal] (18, 2) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBusinessExt_ConcurrencyId] DEFAULT ((1)),
[QuoteResultId] [int] NULL,
[ApplicationReference] [varchar] (100) SPARSE NULL,
[MortgageRepayPercentage] [money] NULL,
[MortgageRepayAmount] [money] NULL,
[IsJointExternal] [bit] NULL,
[IsLendersSolicitorsUsed] [bit] NOT NULL CONSTRAINT [DF_TPolicyBusinessExt_IsLendersSolicitorsUsed] DEFAULT ((0)),
[SystemPortalReference] [varchar] (50) NULL,
[FundIncome] [varchar] (50) NULL,
[IsVisibleToClient] [bit] NOT NULL CONSTRAINT [DF_TPolicyBusinessExt_IsVisibleToClient] DEFAULT ((0)),
[IsVisibilityUpdatedByStatusChange] [bit] NOT NULL CONSTRAINT [DF_TPolicyBusinessExt_IsVisibilityUpdatedByStatusChange] DEFAULT ((1)),
[WhoCreatedUserId] [int] NULL,
[HasDfm] [bit] NOT NULL CONSTRAINT [DF_TPolicyBusinessExt_HasDfm] DEFAULT ((0)),
[HasModelPortfolio] [bit] NOT NULL CONSTRAINT [DF_TPolicyBusinessExt_HasModelPortfolio] DEFAULT ((0)),
[AgencyStatus] [varchar] (50) NULL,
[AgencyStatusDate] [datetime] NULL,
[AdditionalNotes] [varchar] (1000) null,
[InterestRate] [money] NULL,
[IsPlanValueVisibleToClient] [bit] NULL,
[IsTargetMarket] [TINYINT] NULL,
[TargetMarketExplanation] [VARCHAR](250) NULL,
[ModelId] [INT] NULL,
[ForwardIncomeToAdviserId] [int] NULL,
[ForwardIncomeToUseAdviserBanding] [bit] NULL,
[SortCode] [VARCHAR](50) NULL,
[IsProviderManaged] [bit] NULL,
[DocumentDeliveryMethod] [VARCHAR](100) NOT NULL CONSTRAINT [DF_TPolicyBusinessExt_DocumentDeliveryMethod] DEFAULT ('NoPreference')
CONSTRAINT [FK_TPolicyBusinessExt_ModelId] FOREIGN KEY ([ModelId]) REFERENCES TPortfolio([PortfolioId]),
[CreatedAt] [datetime] NULL CONSTRAINT [DF_TPolicyBusinessExt_CreatedAt] DEFAULT (GETUTCDATE()),
[QuoteId] [int] NULL,
[ProgramId] [int] NULL,
[RiskProfileId] [int] NULL
)
GO
ALTER TABLE [dbo].[TPolicyBusinessExt] ADD CONSTRAINT [PK_TPolicyBusinessExt] PRIMARY KEY CLUSTERED  ([PolicyBusinessExtId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusinessExt_BandingTemplateId] ON [dbo].[TPolicyBusinessExt] ([BandingTemplateId])
GO
CREATE NONCLUSTERED INDEX [IX_TPolicyBusinessExt] ON [dbo].[TPolicyBusinessExt] ([MigrationRef], [PolicyBusinessId])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TPolicyBusinessExt_PolicyBusinessId] ON [dbo].[TPolicyBusinessExt] ([PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX [IX_TPolicyBusinessExt_PolicyBusinessId_BandingTemplateId] ON [dbo].[TPolicyBusinessExt] ([PolicyBusinessId], [BandingTemplateId])
GO
CREATE NONCLUSTERED INDEX [IX_TPolicyBusinessExt_1] ON [dbo].[TPolicyBusinessExt] ([PolicyBusinessId], [MigrationRef])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusinessExt_PBId_PortalReference] ON [dbo].[TPolicyBusinessExt] ([PolicyBusinessId], [PortalReference])
GO
CREATE NONCLUSTERED INDEX [IX_TPolicyBusinessExt_QuoteResultId_PolicyBusinessId] ON [dbo].[TPolicyBusinessExt] ([QuoteResultId], [PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX IX_TPolicyBusinessExt_ProgramId ON [dbo].[TPolicyBusinessExt] ([ProgramId])
GO
ALTER TABLE [dbo].[TPolicyBusinessExt] ADD CONSTRAINT [FK_TProgram_ProgramId_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[TProgram] ([ProgramId])
GO
CREATE NONCLUSTERED INDEX  IX_TPolicyBusinessExt_ModelId_PolicyBusinessId  ON TPolicyBusinessExt  ([ModelId], [PolicyBusinessId] )
