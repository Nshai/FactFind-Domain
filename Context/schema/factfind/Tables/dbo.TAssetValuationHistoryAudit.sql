CREATE TABLE [dbo].[TAssetValuationHistoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AssetValuationHistoryId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[AssetId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[Valuation] [money] NOT NULL,
[ValuationDate] [datetime] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ValueUpdatedByUserId] [int] NULL
)
GO
ALTER TABLE [dbo].[TAssetValuationHistoryAudit] ADD CONSTRAINT [PK_TAssetValuationHistoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
