CREATE TABLE [dbo].[TQAirLinkQuestion]
(
[QAirLinkQuestionId] [int] NOT NULL IDENTITY(1, 1),
[QAirLinkCatId] [int] NOT NULL,
[QuestionId] [int] NOT NULL,
[ArchiveFg] [bit] NOT NULL CONSTRAINT [DF_TQAirLinkQ_ArchiveFg_1__60] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQAirLinkQ_ConcurrencyId_2__60] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQAirLinkQuestion] ADD CONSTRAINT [PK_TQAirLinkQuestion_3__60] PRIMARY KEY NONCLUSTERED  ([QAirLinkQuestionId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQAirLinkQuestion_QAirLinkCatId] ON [dbo].[TQAirLinkQuestion] ([QAirLinkCatId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQAirLinkQuestion_QuestionId] ON [dbo].[TQAirLinkQuestion] ([QuestionId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TQAirLinkQuestion] ADD CONSTRAINT [FK_TQAirLinkQuestion_QAirLinkCatId_QAirLinkCatId] FOREIGN KEY ([QAirLinkCatId]) REFERENCES [dbo].[TQAirLinkCat] ([QAirLinkCatId])
GO
ALTER TABLE [dbo].[TQAirLinkQuestion] ADD CONSTRAINT [FK_TQAirLinkQuestion_QuestionId_QuestionId] FOREIGN KEY ([QuestionId]) REFERENCES [dbo].[TQuestion] ([QuestionId])
GO
