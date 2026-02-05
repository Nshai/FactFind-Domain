CREATE TABLE [dbo].[TLeadImportAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[EntryDate] [datetime] NOT NULL CONSTRAINT [DF_TLeadImportAudit_EntryDate] DEFAULT (getdate()),
[FileName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[FileLocation] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[FileUrl] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[DocVersionId] [int] NULL,
[NumberImported] [int] NOT NULL CONSTRAINT [DF_TLeadImportAudit_NumberImported] DEFAULT ((0)),
[NumberFailed] [int] NOT NULL CONSTRAINT [DF_TLeadImportAudit_NumberFailed] DEFAULT ((0)),
[NumberDuplicates] [int] NOT NULL CONSTRAINT [DF_TLeadImportAudit_NumberDuplicates] DEFAULT ((0)),
[Defer] [bit] NOT NULL CONSTRAINT [DF_TLeadImportAudit_Defer] DEFAULT ((0)),
[Imported] [bit] NOT NULL CONSTRAINT [DF_TLeadImportAudit_Imported] DEFAULT ((0)),
[ImportDuplicates] [bit] NOT NULL CONSTRAINT [DF_TLeadImportAudit_ImportDuplicates] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLeadImportAudit_ConcurrencyId] DEFAULT ((1)),
[LeadImportId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TLeadImportAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLeadImportAudit] ADD CONSTRAINT [PK_TLeadImportAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
