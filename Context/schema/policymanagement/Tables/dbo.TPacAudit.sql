CREATE TABLE [dbo].[TPacAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Xml] [text] COLLATE Latin1_General_CI_AS NULL,
[Xsl] [text] COLLATE Latin1_General_CI_AS NULL,
[Extensible] [char] (10) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[PacId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPacAudit_StampDateTime_1__103] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPacAudit] ADD CONSTRAINT [PK_TPacAudit_2__103] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPacAudit_PacId_ConcurrencyId] ON [dbo].[TPacAudit] ([PacId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
