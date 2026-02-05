CREATE TABLE [dbo].[TQAirLinkCat]
(
[QAirLinkCatId] [int] NOT NULL IDENTITY(1, 1),
[QuestionnaireId] [int] NOT NULL,
[QuestionCategoryId] [int] NOT NULL,
[ArchiveFg] [bit] NOT NULL CONSTRAINT [DF_TQAirLinkC_ArchiveFg_1__60] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQAirLinkC_ConcurrencyId_2__60] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQAirLinkCat] ADD CONSTRAINT [PK_TQAirLinkCat_3__60] PRIMARY KEY NONCLUSTERED  ([QAirLinkCatId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQAirLinkCat_QuestionCategoryId] ON [dbo].[TQAirLinkCat] ([QuestionCategoryId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQAirLinkCat_QuestionnaireId] ON [dbo].[TQAirLinkCat] ([QuestionnaireId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TQAirLinkCat] ADD CONSTRAINT [FK_TQAirLinkCat_QuestionCategoryId_QuestionCategoryId] FOREIGN KEY ([QuestionCategoryId]) REFERENCES [dbo].[TQuestionCategory] ([QuestionCategoryId])
GO
ALTER TABLE [dbo].[TQAirLinkCat] ADD CONSTRAINT [FK_TQAirLinkCat_QuestionnaireId_QuestionnaireId] FOREIGN KEY ([QuestionnaireId]) REFERENCES [dbo].[TQuestionnaire] ([QuestionnaireId])
GO
