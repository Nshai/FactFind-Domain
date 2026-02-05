CREATE TABLE [dbo].[TRefFFContactTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ContactTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ValidationExpression] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ArchiveFG] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefFFContactTypeId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefFFContactTypeAudit] ADD CONSTRAINT [PK_TRefFFContactTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefFFContactTypeAudit_RefFFContactTypeId_ConcurrencyId] ON [dbo].[TRefFFContactTypeAudit] ([RefFFContactTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
