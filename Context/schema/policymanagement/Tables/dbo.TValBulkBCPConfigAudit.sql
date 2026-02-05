CREATE TABLE [dbo].[TValBulkBCPConfigAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[BCPConfigId] [int] NULL,
[RefProdProviderId] [int] NOT NULL,
[MappingFile] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ColumnCount] [int] NULL,
[HeaderRowsToStrip] [int] NULL,
[FooterRowsToStrip] [int] NULL,
[UnEvenRowsToStrip] [int] NULL,
[ConcurrencyId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TValBulkBCPConfigAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValBulkBCPConfigAudit] ADD CONSTRAINT [PK_TValBulkBCPConfigAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
