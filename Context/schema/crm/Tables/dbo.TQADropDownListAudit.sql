CREATE TABLE [dbo].[TQADropDownListAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndClientId] [int] NOT NULL,
[ArchiveFg] [bit] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[QADropDownListId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQADropDow_StampDateTime_5__60] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQADropDownListAudit] ADD CONSTRAINT [PK_TQADropDownListAudit_6__60] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TQADropDownListAudit_QADropDownListId_ConcurrencyId] ON [dbo].[TQADropDownListAudit] ([QADropDownListId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
