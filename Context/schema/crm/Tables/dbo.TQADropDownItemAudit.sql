CREATE TABLE [dbo].[TQADropDownItemAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndClientId] [int] NOT NULL,
[ArchiveFg] [bit] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[QADropDownItemId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQADropDow_StampDateTime_1__60] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQADropDownItemAudit] ADD CONSTRAINT [PK_TQADropDownItemAudit_2__60] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TQADropDownItemAudit_QADropDownItemId_ConcurrencyId] ON [dbo].[TQADropDownItemAudit] ([QADropDownItemId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
