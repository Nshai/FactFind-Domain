CREATE TABLE [dbo].[TImportFileMappingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ImportFileId] [int] NOT NULL,
[ColumnName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ImportTypeMappingColumnId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TImportFileMappingAudit_ConcurrencyId] DEFAULT ((1)),
[ImportFileMappingId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TImportFileMappingAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TImportFileMappingAudit] ADD CONSTRAINT [PK_TImportFileMappingAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TImportFileMappingAudit_ImportFileMappingId_ConcurrencyId] ON [dbo].[TImportFileMappingAudit] ([ImportFileMappingId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
