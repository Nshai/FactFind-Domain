CREATE TABLE [dbo].[TValBulkSummary]
(
[ValBulkSummaryId] [int] NOT NULL IDENTITY(1, 1),
[ValScheduleItemId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[DocVersionId] [int] NOT NULL,
[FailedItemsToUpload] [int] NOT NULL CONSTRAINT [DF_TValBulkSummary_FailedItemsToUpload] DEFAULT ((0)),
[TotalItems] [int] NOT NULL CONSTRAINT [DF_TValBulkSummary_TotalItems] DEFAULT ((0)),
[MatchedItems] [int] NOT NULL CONSTRAINT [DF_TValBulkSummary_MatchedItems] DEFAULT ((0)),
[ValuationDate] [datetime] NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TValBulkSummary_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValBulkSummary_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValBulkSummary] ADD CONSTRAINT [PK_TValBulkSummary] PRIMARY KEY CLUSTERED  ([ValBulkSummaryId])
GO
CREATE NONCLUSTERED INDEX IX_TValBulkSummary_IsArchived ON [dbo].[TValBulkSummary] ([IsArchived]) INCLUDE ([ValScheduleItemId])
GO
CREATE NONCLUSTERED INDEX IX_TValBulkSummary_ValScheduleItemId_IsArchived ON [dbo].[TValBulkSummary] ([ValScheduleItemId],[IsArchived])
GO