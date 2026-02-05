CREATE TABLE [dbo].[TRefLoanType]
(
[RefLoanTypeId] [int] NOT NULL IDENTITY(1, 1),
[LoanTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrigoRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefLoanTy_ConcurrencyId_1__63] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefLoanType] ADD CONSTRAINT [PK_TRefLoanType_2__63] PRIMARY KEY NONCLUSTERED  ([RefLoanTypeId]) WITH (FILLFACTOR=80)
GO
