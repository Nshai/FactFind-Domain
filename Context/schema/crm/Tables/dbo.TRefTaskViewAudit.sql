CREATE TABLE [dbo].[TRefTaskViewAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ViewName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[ArchiveFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefTaskViewId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefTaskVi_StampDateTime_1__54] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefTaskViewAudit] ADD CONSTRAINT [PK_TRefTaskViewAudit_2__54] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefTaskViewAudit_RefTaskViewId_ConcurrencyId] ON [dbo].[TRefTaskViewAudit] ([RefTaskViewId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
