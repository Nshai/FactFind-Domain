CREATE TABLE [dbo].[TQuestionnaireAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IndClientId] [int] NOT NULL,
[ArchiveFg] [bit] NOT NULL,
[RefQuestionnaireTypeId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[QuestionnaireId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQuestionn_StampDateTime_1__60] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQuestionnaireAudit] ADD CONSTRAINT [PK_TQuestionnaireAudit_2__60] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TQuestionnaireAudit_QuestionnaireId_ConcurrencyId] ON [dbo].[TQuestionnaireAudit] ([QuestionnaireId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
