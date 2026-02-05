CREATE TABLE [dbo].[TValBulkSummaryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ValScheduleItemId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[DocVersionId] [int] NOT NULL,
[FailedItemsToUpload] [int] NOT NULL,
[TotalItems] [int] NOT NULL,
[MatchedItems] [int] NOT NULL,
[ValuationDate] [datetime] NULL,
[IsArchived] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValBulkSummaryAudit_ConcurrencyId] DEFAULT ((1)),
[ValBulkSummaryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TValBulkSummaryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValBulkSummaryAudit] ADD CONSTRAINT [PK_TValBulkSummaryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
