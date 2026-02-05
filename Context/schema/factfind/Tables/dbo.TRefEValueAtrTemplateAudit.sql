CREATE TABLE [dbo].[TRefEValueAtrTemplateAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefEValueAtrTemplateId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefEValueAtrTemplateAudit] ADD CONSTRAINT [PK_TRefEValueAtrTemplateAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
