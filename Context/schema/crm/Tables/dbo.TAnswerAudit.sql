CREATE TABLE [dbo].[TAnswerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NULL,
[QuestionId] [int] NULL,
[FileCheckId] [int] NULL,
[QADropDownItemId] [int] NULL,
[ResponseText] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[AnswerNotes] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[AnswerId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAnswerAud_StampDateTime_1__91] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAnswerAudit] ADD CONSTRAINT [PK_TAnswerAudit_2__91] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TAnswerAudit_AnswerId_ConcurrencyId] ON [dbo].[TAnswerAudit] ([AnswerId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
