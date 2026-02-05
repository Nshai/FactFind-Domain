CREATE TABLE [dbo].[TExtraRiskQuestionAnswer]
(
[ExtraRiskQuestionAnswerId] [int] NOT NULL IDENTITY(1, 1),
[RefRiskQuestionId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[Answer] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TExtraRiskQuestionAnswer_ConcurrencyId] DEFAULT ((1)),
[Comment] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TExtraRiskQuestionAnswer] ADD CONSTRAINT [PK_TExtraRiskQuestionAnswer] PRIMARY KEY CLUSTERED  ([ExtraRiskQuestionAnswerId])
GO
create index IX_TExtraRiskQuestionAnswer_RefRiskQuestionId on TExtraRiskQuestionAnswer (RefRiskQuestionId)
GO
CREATE NONCLUSTERED INDEX [IX_TExtraRiskQuestionAnswer_CRMContactId] ON [dbo].[TExtraRiskQuestionAnswer] ([CRMContactId])
GO