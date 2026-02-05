CREATE TABLE [dbo].[TSectionFieldAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[SectionId] [int] NULL,
[FieldId] [int] NULL,
[Ordinal] [tinyint] NULL,
[VisibleFg] [bit] NULL,
[EventXml] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[FieldLabel] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TSectionFieldAudit_ConcurrencyId] DEFAULT ((1)),
[SectionFieldId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TSectionFieldAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSectionFieldAudit] ADD CONSTRAINT [PK_TSectionFieldAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
