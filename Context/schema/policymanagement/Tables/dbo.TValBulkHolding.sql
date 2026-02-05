CREATE TABLE [dbo].[TValBulkHolding]
(
[ValBulkHoldingId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ValScheduleItemId] [int] NULL,
[CustomerReference] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[PortfolioReference] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[CustomerSubType] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Title] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[FirstName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[LastName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[CorporateName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[DOB] [datetime] NULL,
[NINumber] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ClientAddressLine1] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ClientAddressLine2] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ClientAddressLine3] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ClientAddressLine4] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ClientPostCode] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[AdviserReference] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[AdviserFirstName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[AdviserLastName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[CompanyName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AdviserPostCode] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[PortfolioId] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[HoldingId] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PortfolioType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Designation] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FundProviderName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FundName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ISIN] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[MexId] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Sedol] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Quantity] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[EffectiveDate] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Price] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[PriceDate] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[HoldingValue] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Currency] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[WorkInProgress] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NULL,
[PractitionerId] [int] NULL,
[PolicyBusinessId] [int] NULL,
[Status] [varchar] (600) COLLATE Latin1_General_CI_AS NULL,
[IsLatestFG] [int] NOT NULL CONSTRAINT [DF_TValBulkHolding_IsLatestFG] DEFAULT ((0)),
[SubPlanReference] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[SubPlanType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[EpicCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CitiCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[GBPBalance] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ForeignBalance] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AvailableCash] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AccountName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AccountReference] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PolicyProviderName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ProviderFundCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValBulkHolding_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValBulkHolding] ADD CONSTRAINT [PK_TValBulkHolding] PRIMARY KEY NONCLUSTERED  ([ValBulkHoldingId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TValBulkHolding_ValScheduleItemId] ON [dbo].[TValBulkHolding] ([ValScheduleItemId])
GO
CREATE NONCLUSTERED INDEX [IX_INCL_TValBulkHolding_ValScheduleItemId_PolicyBusinessId_Status_IsLatestFG] ON [dbo].[TValBulkHolding] ([ValScheduleItemId], [PolicyBusinessId], [Status], [IsLatestFG])
GO
CREATE NONCLUSTERED INDEX IDX_TValBulkHolding_CustomerReference ON TValBulkHolding (CustomerReference)  
GO
CREATE NONCLUSTERED INDEX IDX_TValBulkHolding_PortfolioReference ON TValBulkHolding (PortfolioReference)  
GO
CREATE NONCLUSTERED INDEX IDX_TValBulkHolding_PolicyBusinessId ON TValBulkHolding (PolicyBusinessId)  
GO
CREATE NONCLUSTERED INDEX IDX_TValBulkHolding_ValScheduleItemId_NINumber ON TValBulkHolding (ValScheduleItemId, NINumber) 
GO
CREATE NONCLUSTERED INDEX IDX_TValBulkHolding_ValScheduleItemId_LastName_DOB_ClientPostCode ON TValBulkHolding (ValScheduleItemId, LastName, DOB, ClientPostCode)  
GO
CREATE NONCLUSTERED INDEX [IDX_TValBulkHolding_IsLatestFg_NINumber] ON [dbo].[TValBulkHolding] ([NINumber],[IsLatestFG]) INCLUDE ([CustomerReference])
GO
CREATE NONCLUSTERED INDEX IDX_TValBulkHolding_PortfolioType ON TValBulkHolding (PortfolioType) 
GO