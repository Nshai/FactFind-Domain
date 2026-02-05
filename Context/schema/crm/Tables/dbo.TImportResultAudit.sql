CREATE TABLE [dbo].[TImportResultAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ImportFileId] [int] NOT NULL,
[LineNumber] [int] NULL,
[Descriptor] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[Result] [bit] NULL,
[IOEntityTypeId] [int] NULL,
[EntityId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TImportResultAudit_ConcurrencyId] DEFAULT ((1)),
[ImportResultId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TImportResultAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TImportResultAudit] ADD CONSTRAINT [PK_TImportResultAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TImportResultAudit_ImportResultId_ConcurrencyId] ON [dbo].[TImportResultAudit] ([ImportResultId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
