CREATE TABLE [dbo].[TStochasticIllustrationResult]
(
[StochasticIllustrationResultId] [int] NOT NULL IDENTITY(1, 1),
[ObjectiveId] [int] NOT NULL,
[Term] [int] NOT NULL,
[InputValue] [int] NOT NULL,
[LowerReturn] [int] NOT NULL,
[MidReturn] [int] NOT NULL,
[UpperReturn] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TStochasticIllustrationResult_ConcurrencyId] DEFAULT ((1))
)
GO
