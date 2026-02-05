CREATE TABLE [dbo].[TLoanProfileQuestion]
(
[LoanProfileQuestionId] [int] NOT NULL IDENTITY(1, 1),
[QuestionText] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
