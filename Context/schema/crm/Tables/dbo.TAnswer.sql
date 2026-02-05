CREATE TABLE [dbo].[TAnswer]
(
[AnswerId] [int] NOT NULL IDENTITY(1, 1),
[QuestionId] [int] NULL,
[CRMContactId] [int] NULL,
[FileCheckId] [int] NULL,
[QADropDownItemId] [int] NULL,
[ResponseText] [varchar] (100)  NULL,
[AnswerNotes] [varchar] (250)  NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAnswer_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAnswer] ADD CONSTRAINT [PK_TAnswer] PRIMARY KEY NONCLUSTERED  ([AnswerId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAnswer_CRMContactId] ON [dbo].[TAnswer] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAnswer_QADropDownItemId] ON [dbo].[TAnswer] ([QADropDownItemId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAnswer_QuestionId] ON [dbo].[TAnswer] ([QuestionId])
GO
ALTER TABLE [dbo].[TAnswer] WITH CHECK ADD CONSTRAINT [FK_TAnswer_CRMContactId_CRMContactId] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TAnswer] ADD CONSTRAINT [FK_TAnswer_QADropDownItemId_QADropDownItemId] FOREIGN KEY ([QADropDownItemId]) REFERENCES [dbo].[TQADropDownItem] ([QADropDownItemId])
GO
ALTER TABLE [dbo].[TAnswer] ADD CONSTRAINT [FK_TAnswer_QuestionId_QuestionId] FOREIGN KEY ([QuestionId]) REFERENCES [dbo].[TQuestion] ([QuestionId])
GO
