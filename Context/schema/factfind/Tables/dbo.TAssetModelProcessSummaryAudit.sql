CREATE TABLE [dbo].[TAssetModelProcessSummaryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[AtrTemplateId] [int] NOT NULL,
[RefPortfolioTypeId] [int] NULL,
[DocVersionId] [int] NOT NULL,
[ProcessStatus] varchar(100) Not Null,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAssetModelProcessSummaryAudit_ConcurrencyId] DEFAULT ((1)),
[AssetModelProcessSummaryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAssetModelProcessSummaryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAssetModelProcessSummaryAudit] ADD CONSTRAINT [PK_TAssetModelProcessSummaryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
