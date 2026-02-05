CREATE TABLE [dbo].[TValBulkHoldingResult]
(
[ValBulkHoldingResultId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ValBulkHoldingId] [int] NULL,
[IndigoClientId] [int] NULL,
[ValScheduleId] [int] NULL,
[ValScheduleItemId] [int] NULL,
[PolicyProviderName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CustomerReference] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[PortfolioReference] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[PortfolioType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AdviserReference] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[PlanMatched] [bit] NULL,
[PolicyBusinessId] [int] NULL,
[FundMatched] [bit] NULL,
[PolicyBusinessFundId] [int] NULL,
[FundID] [int] NULL,
[FundName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FundUnitPrice] [money] NULL,
[FundQuantity] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FundPriceDate] [datetime] NULL,
[FundTypeId] [int] NULL,
[CategoryId] [int] NULL,
[CategoryName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Feed] [bit] NULL,
[PlanUpdateBreaker] [bit] NULL,
[FundDeleteBreaker] [bit] NULL,
[FundUpdateBreaker] [bit] NULL,
[ValuationUpdated] [bit] NULL,
[PlanValuationId] [bigint] NULL,
[PlanInEligibilityMask] [int] NULL,
[CreatedDateTime] DATETIME NULL,
[Remarks] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL
)
GO
ALTER TABLE [dbo].[TValBulkHoldingResult] ADD CONSTRAINT [PK_TValBulkHoldingResult] PRIMARY KEY NONCLUSTERED  ([ValBulkHoldingResultId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TValBulkHoldingResult_ValScheduleId] ON [dbo].[TValBulkHoldingResult] ([ValScheduleId]) INCLUDE ([IndigoClientId],[CustomerReference],[PortfolioReference],[PlanMatched],[PolicyBusinessId],[Remarks],[PortfolioType],[AdviserReference])
GO

