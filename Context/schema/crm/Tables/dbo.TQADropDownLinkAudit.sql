CREATE TABLE [dbo].[TQADropDownLinkAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QADropDownListId] [int] NOT NULL,
[QADropDownItemId] [int] NOT NULL,
[IndClientId] [int] NOT NULL,
[ArchiveFg] [bit] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[QADropDownLinkId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQADropDow_StampDateTime_3__60] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQADropDownLinkAudit] ADD CONSTRAINT [PK_TQADropDownLinkAudit_4__60] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TQADropDownLinkAudit_QADropDownLinkId_ConcurrencyId] ON [dbo].[TQADropDownLinkAudit] ([QADropDownLinkId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
