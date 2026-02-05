CREATE TABLE [dbo].[TFileImportResultAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FileImportId] [int] NOT NULL,
[Identifier] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[LineNumber] [int] NOT NULL,
[Descriptor] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[RefFileImportTypeId] [int] NULL,
[Result] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFileImportResultAudit_ConcurrencyId] DEFAULT ((1)),
[FileImportResultId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFileImportResultAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFileImportResultAudit] ADD CONSTRAINT [PK_TFileImportResultAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
