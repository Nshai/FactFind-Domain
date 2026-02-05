CREATE TABLE [dbo].[TRefXSLTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefXSLTypeAudit_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefXSLTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefXSLTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefXSLTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefXSLTypeAudit] ADD CONSTRAINT [PK_TRefXSLTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefXSLTypeAudit_RefXSLTypeId_ConcurrencyId] ON [dbo].[TRefXSLTypeAudit] ([RefXSLTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
