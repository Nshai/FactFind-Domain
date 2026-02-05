CREATE TABLE [dbo].[TRefLoanState]
(
[RefLoanStateId] [int] NOT NULL IDENTITY(1, 1),
[LoanStateName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrigoRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefLoanSt_ConcurrencyId_1__63] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefLoanState] ADD CONSTRAINT [PK_TRefLoanState_2__63] PRIMARY KEY NONCLUSTERED  ([RefLoanStateId]) WITH (FILLFACTOR=80)
GO
