create TABLE [dbo].[TValBulkQStage](
	[ValScheduleId] [int] NOT NULL,
	[PolicyProviderName] [varchar](255) NULL,
	[CustomerReference] [varchar](100) NULL,
	[PortfolioType] [varchar](100) NULL,
	[PortfolioReference] [varchar](100) NULL,
	[Sedol] [varchar](50) NULL,
	[MexId] [varchar](50) NULL,
	[ISIN] [varchar](50) NULL,
	[EpicCode] [varchar](50) NULL,
	[CitiCode] [varchar](50) NULL,
	[ProviderFundCode] [varchar](50) NULL,
	[FundName] [varchar](255) NULL,
	[FundQuantity] [varchar](50) NULL,
	[EffectiveDate] [varchar](50) NULL,
	[Price] [varchar](50) NULL,
	[FundPriceDate] [varchar](50) NULL,
	[Currency] [varchar](50) NULL,
	[CustomerFirstName] [varchar](100) NULL,
	[CustomerLastName] [varchar](100) NULL,
	[CustomerNINumber] [varchar](50) NULL,
	[CustomerDoB] [varchar](50) NULL,
	[CustomerPostCode] [varchar](20) NULL,
	[AdviserFirstName] [varchar](100) NULL,
	[AdviserLastName] [varchar](100) NULL,
	[Qtimestamp] [datetime2](7) NULL,
	[ModelPortfolioName] [varchar] (2000) NULL,
	[DFMName] [varchar] (2000) NULL
)
GO
CREATE CLUSTERED INDEX CIX_TValBulkQStage_ValScheduleId on TValBulkQStage (ValScheduleId) 
go
alter table TValBulkQStage SET ( LOCK_ESCALATION = DISABLE )
GO
