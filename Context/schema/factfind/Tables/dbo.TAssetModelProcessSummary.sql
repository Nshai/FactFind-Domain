CREATE TABLE [dbo].[TAssetModelProcessSummary]
(
[AssetModelProcessSummaryId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[AtrTemplateId] [int] NOT NULL,
[RefPortfolioTypeId] [int] NULL,
[DocVersionId] [int] NOT NULL,
[ProcessStatus] varchar(100) Not Null,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAssetModelProcessSummary_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAssetModelProcessSummary] ADD CONSTRAINT [PK_TAssetModelProcessSummary] PRIMARY KEY CLUSTERED  ([AssetModelProcessSummaryId])
GO
