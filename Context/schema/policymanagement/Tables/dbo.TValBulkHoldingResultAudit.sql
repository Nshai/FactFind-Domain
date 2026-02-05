CREATE TABLE [dbo].[TValBulkHoldingResultAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ValBulkHoldingResultId] [int] NULL,
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
[FundQuantity] [varchar] (50) NULL,
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
[Remarks] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[CreatedDateTime] DATETIME NULL,
[ConcurrencyId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TValBulkHoldingResultAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValBulkHoldingResultAudit] ADD CONSTRAINT [PK_TValBulkHoldingResultAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO

