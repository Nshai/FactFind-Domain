CREATE TABLE [dbo].[TFundAssetSummaryAudit](
	[AuditId] [int] NOT NULL IDENTITY(1, 1),
	[EquityId] [int] NULL,
	[FundId] [int] NULL,
	[UpdatedByUserId] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[TenantId] [int] NULL,
	[IsEquity] [bit] NULL,
	[IsFromFeed] [bit] NULL,
	[ConcurrencyId] [int] NULL,
	[FundAssetSummaryId] [int] NULL,
	[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFundAssetSummaryAudit] ADD CONSTRAINT [PK_TFundAssetSummaryAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO




