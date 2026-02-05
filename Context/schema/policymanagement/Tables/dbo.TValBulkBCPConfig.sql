CREATE TABLE [dbo].[TValBulkBCPConfig]
(
[BCPConfigId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NOT NULL,
[MappingFile] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ColumnCount] [int] NOT NULL CONSTRAINT [DF_TValBulkBCPConfig_ColumnCount] DEFAULT ((0)),
[HeaderRowsToStrip] [int] NOT NULL CONSTRAINT [DF_TValBulkBCPConfig_HeaderRowsToStrip] DEFAULT ((0)),
[FooterRowsToStrip] [int] NOT NULL CONSTRAINT [DF_TValBulkBCPConfig_FooterRowsToStrip] DEFAULT ((0)),
[UnEvenRowsToStrip] [int] NOT NULL CONSTRAINT [DF_TValBulkBCPConfig_UnEvenRowsToStrip] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValBulkBCPConfig_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValBulkBCPConfig] ADD CONSTRAINT [PK_TValBulkBCPConfig] PRIMARY KEY CLUSTERED  ([BCPConfigId])
GO
