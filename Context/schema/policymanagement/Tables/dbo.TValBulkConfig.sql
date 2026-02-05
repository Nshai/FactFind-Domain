CREATE TABLE [dbo].[TValBulkConfig]
(
[ValBulkConfigId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NOT NULL,
[MatchingCriteria] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[DownloadDay] [varchar] (25) COLLATE Latin1_General_CI_AS NULL,
[DownloadTime] [varchar] (25) COLLATE Latin1_General_CI_AS NULL,
[ProcessDay] [varchar] (25) COLLATE Latin1_General_CI_AS NULL,
[ProcessTime] [varchar] (25) COLLATE Latin1_General_CI_AS NULL,
[ProviderFileDateOffset] [smallint] NOT NULL CONSTRAINT [DF_TValBulkConfig_ProviderFileDateOffset] DEFAULT ((0)),
[URL] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RequestXSL] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[FieldNames] [varchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[TransformXSL] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Protocol] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SupportedService] [int] NULL,
[SupportedFileTypeId] [int] NULL,
[SupportedDelimiter] [varchar] (25) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValBulkConfig_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValBulkConfig] ADD CONSTRAINT [PK_TValBulkConfig] PRIMARY KEY NONCLUSTERED  ([ValBulkConfigId])
GO
