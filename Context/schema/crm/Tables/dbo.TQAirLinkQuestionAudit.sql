CREATE TABLE [dbo].[TQAirLinkQuestionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QAirLinkCatId] [int] NOT NULL,
[QuestionId] [int] NOT NULL,
[ArchiveFg] [bit] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[QAirLinkQuestionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQAirLinkQ_StampDateTime_1__60] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQAirLinkQuestionAudit] ADD CONSTRAINT [PK_TQAirLinkQuestionAudit_2__60] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TQAirLinkQuestionAudit_QAirLinkQuestionId_ConcurrencyId] ON [dbo].[TQAirLinkQuestionAudit] ([QAirLinkQuestionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
