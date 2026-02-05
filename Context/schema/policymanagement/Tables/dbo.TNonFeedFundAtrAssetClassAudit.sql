CREATE TABLE [dbo].[TNonFeedFundAtrAssetClassAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[NonFeedFundAtrAssetClassId] [int] NOT NULL,
[NonFeedFundId] [int] NOT NULL,
[Recommended] [bit] NULL,
[TenantId] [int] NOT NULL,
[AtrRefAssetClassId] [int] NULL,
[Allocation] [decimal] (5, 2) NULL,
[IsEquity] [bit] NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF__TNonFeedF__Stamp__2A5703AD] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TNonFeedFundAtrAssetClassAudit] ADD CONSTRAINT [PK_TNonFeedFundAtrAssetClassAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
