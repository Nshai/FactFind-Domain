CREATE TABLE [dbo].[TQADependentQuestion]
(
[QADependentQuestionId] [int] NOT NULL IDENTITY(1, 1),
[ParentQuestionId] [int] NULL,
[QADropDownLinkId] [int] NULL,
[ChildQuestionId] [int] NULL,
[ArchiveFg] [bit] NOT NULL CONSTRAINT [DF_TQADepende_ArchiveFg_1__60] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQADepende_ConcurrencyId_2__60] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQADependentQuestion] ADD CONSTRAINT [PK_TQADependentQuestion_3__60] PRIMARY KEY NONCLUSTERED  ([QADependentQuestionId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQADependentQuestion_ChildQuestionId] ON [dbo].[TQADependentQuestion] ([ChildQuestionId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQADependentQuestion_ParentQuestionId] ON [dbo].[TQADependentQuestion] ([ParentQuestionId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQADependentQuestion_QADropDownLinkId] ON [dbo].[TQADependentQuestion] ([QADropDownLinkId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TQADependentQuestion] ADD CONSTRAINT [FK_TQADependentQuestion_ChildQuestionId_QuestionId] FOREIGN KEY ([ChildQuestionId]) REFERENCES [dbo].[TQuestion] ([QuestionId])
GO
ALTER TABLE [dbo].[TQADependentQuestion] ADD CONSTRAINT [FK_TQADependentQuestion_ParentQuestionId_QuestionId] FOREIGN KEY ([ParentQuestionId]) REFERENCES [dbo].[TQuestion] ([QuestionId])
GO
ALTER TABLE [dbo].[TQADependentQuestion] ADD CONSTRAINT [FK_TQADependentQuestion_QADropDownLinkId_QADropDownLinkId] FOREIGN KEY ([QADropDownLinkId]) REFERENCES [dbo].[TQADropDownLink] ([QADropDownLinkId])
GO
