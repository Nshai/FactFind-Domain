CREATE TABLE [dbo].[TImportTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[InternalIdentifier] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ImportTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[DTOObjectName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TImportTypeAudit_ConcurrencyId] DEFAULT ((1)),
[ImportTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TImportTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TImportTypeAudit] ADD CONSTRAINT [PK_TImportTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TImportTypeAudit_ImportTypeId_ConcurrencyId] ON [dbo].[TImportTypeAudit] ([ImportTypeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
