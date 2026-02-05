CREATE TABLE [dbo].[TQuestion]
(
[QuestionId] [int] NOT NULL IDENTITY(1, 1),
[Question] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL,
[QADropDownListId] [int] NULL,
[IndClientId] [int] NOT NULL,
[ArchiveFg] [bit] NOT NULL CONSTRAINT [DF_TQuestion_ArchiveFg_1__60] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuestion_ConcurrencyId_2__60] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQuestion] ADD CONSTRAINT [PK_TQuestion_3__60] PRIMARY KEY NONCLUSTERED  ([QuestionId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQuestion_QADropDownListId] ON [dbo].[TQuestion] ([QADropDownListId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TQuestion] ADD CONSTRAINT [FK_TQuestion_QADropDownListId_QADropDownListId] FOREIGN KEY ([QADropDownListId]) REFERENCES [dbo].[TQADropDownList] ([QADropDownListId])
GO
