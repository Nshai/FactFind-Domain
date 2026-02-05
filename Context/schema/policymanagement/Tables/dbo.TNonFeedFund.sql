SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TNonFeedFund]
(
[NonFeedFundId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ComputedId] AS ( 'M' + CONVERT(varchar(10), NonFeedFundId) ) PERSISTED,
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
[IsClosed] [bit] NOT NULL CONSTRAINT [DF_TNonFeedFund_IsClosed] DEFAULT ((0)),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TNonFeedFund_IsArchived_1] DEFAULT ((0)),
[IncomeYield] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TNonFeedFund_ConcurrencyId] DEFAULT ((1)),
[ISIN] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Epic] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Citi] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ProviderFundCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RefProdProviderId] [int] NULL,
[LastUpdatedByPlan] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TNonFeedFund] ADD  CONSTRAINT [PK_TNonFeedFund] PRIMARY KEY CLUSTERED ([NonFeedFundId]) WITH (SORT_IN_TEMPDB = OFF)
GO
CREATE NONCLUSTERED INDEX [IX_TNonFeedFund_IndigoClientId_RefProdProviderId] ON [dbo].[TNonFeedFund]([IndigoClientId],[RefProdProviderId]) INCLUDE ([FundName],[ProviderFundCode]) WITH (SORT_IN_TEMPDB = ON)
GO
CREATE NONCLUSTERED INDEX [IX_TNonFeedFund_PriceDate_INCL] ON [dbo].[TNonFeedFund]([PriceDate]) INCLUDE ([NonFeedFundId], [CurrentPrice])
GO
CREATE NONCLUSTERED INDEX [IX_NonFeedFund_ComputedId] ON [dbo].[TNonFeedFund] ([ComputedId], [NonFeedFundId])
GO