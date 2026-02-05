CREATE TABLE [dbo].[TQAirLinkCatAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuestionnaireId] [int] NOT NULL,
[QuestionCategoryId] [int] NOT NULL,
[ArchiveFg] [bit] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[QAirLinkCatId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQAirLinkC_StampDateTime_1__60] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQAirLinkCatAudit] ADD CONSTRAINT [PK_TQAirLinkCatAudit_2__60] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TQAirLinkCatAudit_QAirLinkCatId_ConcurrencyId] ON [dbo].[TQAirLinkCatAudit] ([QAirLinkCatId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
