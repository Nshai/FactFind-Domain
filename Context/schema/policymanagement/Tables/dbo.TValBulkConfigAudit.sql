CREATE TABLE [dbo].[TValBulkConfigAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NOT NULL,
[MatchingCriteria] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[DownloadDay] [varchar] (25) COLLATE Latin1_General_CI_AS NULL,
[DownloadTime] [varchar] (25) COLLATE Latin1_General_CI_AS NULL,
[ProcessDay] [varchar] (25) COLLATE Latin1_General_CI_AS NULL,
[ProcessTime] [varchar] (25) COLLATE Latin1_General_CI_AS NULL,
[ProviderFileDateOffset] [smallint] NOT NULL CONSTRAINT [DF_TValBulkConfigAudit_ProviderFileDateOffset] DEFAULT ((0)),
[URL] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RequestXSL] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[FieldNames] [varchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[TransformXSL] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Protocol] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SupportedService] [int] NULL,
[SupportedFileTypeId] [int] NULL,
[SupportedDelimiter] [varchar] (25) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValBulkConfigAudit_ConcurrencyId] DEFAULT ((1)),
[ValBulkConfigId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TValBulkConfigAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValBulkConfigAudit] ADD CONSTRAINT [PK_TValBulkConfigAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TValBulkConfigAudit_ValBulkConfigId_ConcurrencyId] ON [dbo].[TValBulkConfigAudit] ([ValBulkConfigId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
