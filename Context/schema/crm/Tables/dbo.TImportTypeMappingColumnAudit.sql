CREATE TABLE [dbo].[TImportTypeMappingColumnAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ImportTypeId] [int] NOT NULL,
[ColumnName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[DisplayName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[PropertyName] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[IsRequired] [bit] NOT NULL CONSTRAINT [DF_TImportTypeMappingColumnAudit_IsRequired] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TImportTypeMappingColumnAudit_ConcurrencyId] DEFAULT ((1)),
[ImportTypeMappingColumnId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TImportTypeMappingColumnAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TImportTypeMappingColumnAudit] ADD CONSTRAINT [PK_TImportTypeMappingColumnAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TImportTypeMappingColumnAudit_ImportTypeMappingColumnId_ConcurrencyId] ON [dbo].[TImportTypeMappingColumnAudit] ([ImportTypeMappingColumnId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
