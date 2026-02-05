CREATE TABLE [dbo].[TRefEvalueCashflowType]
(
[RefEvalueCashflowTypeId] [int] NOT NULL IDENTITY(1, 1),
[EvalueCashflowTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[EvalueCashflowTypeLevel1] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[EvalueCashflowTypeLevel2] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[EvalueCashflowProductName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TRefEvalueCashflowType] ADD CONSTRAINT [PK_TRefEvalueCashflowType] PRIMARY KEY CLUSTERED  ([RefEvalueCashflowTypeId])
GO
