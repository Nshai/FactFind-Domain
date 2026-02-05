CREATE TABLE [dbo].[TQuestionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Question] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL,
[QADropDownListId] [int] NULL,
[IndClientId] [int] NOT NULL,
[ArchiveFg] [bit] NOT NULL CONSTRAINT [DF_TQuestionA_ArchiveFg_1__56] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[QuestionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQuestionA_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQuestionAudit] ADD CONSTRAINT [PK_TQuestionAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TQuestionAudit_QuestionId_ConcurrencyId] ON [dbo].[TQuestionAudit] ([QuestionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
