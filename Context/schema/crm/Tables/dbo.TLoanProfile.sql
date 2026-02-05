CREATE TABLE [dbo].[TLoanProfile]
(
[LoanProfileId] [int] NOT NULL IDENTITY(1, 1),
[ReviewId] [int] NOT NULL,
[LoanProfileQuestionId] [int] NOT NULL,
[C1Answer] [bit] NOT NULL,
[C2Answer] [bit] NOT NULL,
[CJAnswer] [bit] NOT NULL,
[Details] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
