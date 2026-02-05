CREATE TABLE [dbo].[TRefSubjectAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[Subject] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefSubjectId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefSubjectAudit] ADD CONSTRAINT [PK_TRefSubjectAudit_1__54] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefSubjectAudit_RefSubjectId_ConcurrencyId] ON [dbo].[TRefSubjectAudit] ([RefSubjectId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
