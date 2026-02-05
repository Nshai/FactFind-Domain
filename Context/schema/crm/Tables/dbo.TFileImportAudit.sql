CREATE TABLE [dbo].[TFileImportAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefFileImportTypeId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[EntryDate] [datetime] NOT NULL,
[DocVersionId] [int] NOT NULL,
[FailedDocVersionId] [int] NULL,
[NumberImported] [int] NOT NULL,
[IsImported] [int] NOT NULL,
[NumberFailed] [int] NOT NULL,
[NumberDuplicates] [int] NOT NULL,
[RefFileImportStatusId] [int] NOT NULL,
[ShouldImportDuplicates] [bit] NOT NULL,
[StatusDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFileImportAudit_ConcurrencyId] DEFAULT ((1)),
[FileImportId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFileImportAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFileImportAudit] ADD CONSTRAINT [PK_TFileImportAudit] PRIMARY KEY CLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
