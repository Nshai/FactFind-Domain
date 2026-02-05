CREATE TABLE [dbo].[TNonFeedFundAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[FundTypeId] [int] NOT NULL,
[FundTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[FundName] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[CompanyId] [int] NULL,
[CompanyName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CategoryId] [int] NULL,
[CategoryName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Sedol] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[MexId] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[CurrentPrice] [float] NULL,
[PriceDate] [datetime] NULL,
[PriceUpdatedByUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsClosed] [bit] NOT NULL CONSTRAINT [DF_TNonFeedFundAudit_IsClosed] DEFAULT ((0)),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TNonFeedFundAudit_IsArchived] DEFAULT ((0)),
[IncomeYield] [money] NULL,
[ConcurrencyId] [int] NOT NULL,
[NonFeedFundId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ISIN] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Epic] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Citi] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ProviderFundCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RefProdProviderId] [int] NULL,
[LastUpdatedByPlan] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TNonFeedFundAudit] ADD CONSTRAINT [PK_TNonFeedFundAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
