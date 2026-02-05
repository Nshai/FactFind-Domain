CREATE TABLE [dbo].[TFundAssetAllocationAudit](
	[AuditId] [int] NOT NULL IDENTITY(1, 1),
	[FundAssetSummaryId] [int] NULL,
	[AtrRefAssetClassId] [int] NULL,
	[PercentageAllocation] [decimal](18, 2) NULL,
	[ConcurrencyId] [int] NULL,
	[FundAssetAllocationId] [int] NULL,
	[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)

GO
ALTER TABLE [dbo].[TFundAssetAllocationAudit] ADD CONSTRAINT [PK_TFundAssetAllocationAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
