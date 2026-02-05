CREATE TABLE [dbo].[TRefRiskQuestion]
(
[RefRiskQuestionId] [int] NOT NULL IDENTITY(1, 1),
[Question] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [int] NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefRiskQuestion_IsArchived] DEFAULT ((0)),
[CreatedBy] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefRiskQuestion_ConcurrencyId] DEFAULT ((1)),
[RefRiskCommentId] [int] NULL
)
GO
ALTER TABLE [dbo].[TRefRiskQuestion] ADD CONSTRAINT [PK_TRefRiskQuestion] PRIMARY KEY CLUSTERED  ([RefRiskQuestionId])
GO
