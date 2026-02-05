CREATE TABLE [dbo].[TImportFileAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[ImportTypeId] [int] NOT NULL,
[PartyId] [int] NOT NULL,
[EntryDate] [datetime] NOT NULL,
[OriginalFileName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[OriginalFilePath] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[FileSize] [int] NULL,
[DocVersionId] [int] NULL,
[ProcessedTimeStamp] [datetime] NULL,
[ProcessStartTimeStamp] [datetime] NULL,
[PotentialImports] [int] NULL,
[NumberImported] [int] NULL,
[NumberFailed] [int] NULL,
[NumberDuplicates] [int] NULL,
[IsDeferred] [bit] NOT NULL CONSTRAINT [DF_TImportFileAudit_IsDeferred] DEFAULT ((0)),
[IsAllowDuplicates] [bit] NOT NULL CONSTRAINT [DF_TImportFileAudit_IsAllowDuplicates] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TImportFileAudit_ConcurrencyId] DEFAULT ((1)),
[ImportFileId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TImportFileAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TImportFileAudit] ADD CONSTRAINT [PK_TImportFileAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TImportFileAudit_ImportFileId_ConcurrencyId] ON [dbo].[TImportFileAudit] ([ImportFileId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
