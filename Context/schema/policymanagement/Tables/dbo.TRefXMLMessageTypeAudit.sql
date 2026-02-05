CREATE TABLE [dbo].[TRefXMLMessageTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefXMLMessageTypeAudit_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefXMLMessageTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefXMLMessageTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefXMLMessageTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefXMLMessageTypeAudit] ADD CONSTRAINT [PK_TRefXMLMessageTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefXMLMessageTypeAudit_RefXMLMessageTypeId_ConcurrencyId] ON [dbo].[TRefXMLMessageTypeAudit] ([RefXMLMessageTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
