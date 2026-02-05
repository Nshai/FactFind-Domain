CREATE TABLE [dbo].[TRefLoanRepaymentType]
(
[RefLoanRepaymentTypeId] [int] NOT NULL IDENTITY(1, 1),
[PaymentTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrigoRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [tinyint] NOT NULL CONSTRAINT [DF_TRefLoanRepaymentType_RetireFg] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefLoanRe_ConcurrencyId_1__63] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefLoanRepaymentType] ADD CONSTRAINT [PK_TRefLoanRepaymentType_2__63] PRIMARY KEY NONCLUSTERED  ([RefLoanRepaymentTypeId]) WITH (FILLFACTOR=80)
GO
