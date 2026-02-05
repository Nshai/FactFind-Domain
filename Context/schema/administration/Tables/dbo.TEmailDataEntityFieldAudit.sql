CREATE TABLE [dbo].[TEmailDataEntityFieldAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Descriptor] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[EmailDataEntityId] [int] NOT NULL,
[Identifier] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[XPath] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEmailDataEntityFieldAudit_ConcurrencyId] DEFAULT ((1)),
[EmailDataEntityFieldId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEmailDataEntityFieldAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEmailDataEntityFieldAudit] ADD CONSTRAINT [PK_TEmailDataEntityFieldAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
