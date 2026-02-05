CREATE TABLE [dbo].[TQuestionnaire]
(
[QuestionnaireId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IndClientId] [int] NOT NULL,
[ArchiveFg] [bit] NOT NULL CONSTRAINT [DF_TQuestionn_ArchiveFg_1__60] DEFAULT ((0)),
[RefQuestionnaireTypeId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuestionn_ConcurrencyId_2__60] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQuestionnaire] ADD CONSTRAINT [PK_TQuestionnaire_3__60] PRIMARY KEY NONCLUSTERED  ([QuestionnaireId]) WITH (FILLFACTOR=80)
GO
