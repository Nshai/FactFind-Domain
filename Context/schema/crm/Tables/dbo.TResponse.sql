CREATE TABLE [dbo].[TResponse]
(
[ResponseId] [int] NOT NULL IDENTITY(1, 1),
[QuestionId] [int] NOT NULL,
[Answer] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRiskRespo_ConcurrencyId_1__58] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TResponse] ADD CONSTRAINT [PK_TRiskResponse_2__58] PRIMARY KEY NONCLUSTERED  ([ResponseId]) WITH (FILLFACTOR=80)
GO
