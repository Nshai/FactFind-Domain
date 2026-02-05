CREATE TABLE [dbo].[TPolicyLoan]
(
[PolicyLoanId] [int] NOT NULL IDENTITY(1, 1),
[PolicyDetailId] [int] NOT NULL,
[RefLoanRepaymentTypeId] [int] NULL,
[RefLoanTypeId] [int] NULL,
[PercentageCapRep] [decimal] (18, 0) NULL,
[PercentageIntOnly] [decimal] (18, 0) NULL,
[LoanTypePeriod] [float] NULL,
[CombinationDetails] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[InitialLoanAmount] [money] NULL,
[PurchasePrice] [money] NULL,
[CurrentPropertyValue] [money] NULL,
[DatePropertyValueUpdated] [datetime] NULL,
[CurrentLoanAmount] [money] NULL,
[DateLoanAmountUpdated] [datetime] NULL,
[MigFg] [bit] NULL,
[MigAmount] [money] NULL,
[RedemptionPenaltyFg] [bit] NULL,
[RedemptionPenaltyDetails] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyLoan_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPolicyLoan] ADD CONSTRAINT [PK_TPolicyLoan] PRIMARY KEY NONCLUSTERED  ([PolicyLoanId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyLoan_PolicyDetailId] ON [dbo].[TPolicyLoan] ([PolicyDetailId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyLoan_RefLoanRepaymentTypeId] ON [dbo].[TPolicyLoan] ([RefLoanRepaymentTypeId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyLoan_RefLoanTypeId] ON [dbo].[TPolicyLoan] ([RefLoanTypeId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TPolicyLoan] ADD CONSTRAINT [FK_TPolicyLoan_PolicyDetailId_PolicyDetailId] FOREIGN KEY ([PolicyDetailId]) REFERENCES [dbo].[TPolicyDetail] ([PolicyDetailId])
GO
ALTER TABLE [dbo].[TPolicyLoan] ADD CONSTRAINT [FK_TPolicyLoan_RefLoanRepaymentTypeId_RefLoanRepaymentTypeId] FOREIGN KEY ([RefLoanRepaymentTypeId]) REFERENCES [dbo].[TRefLoanRepaymentType] ([RefLoanRepaymentTypeId])
GO
ALTER TABLE [dbo].[TPolicyLoan] ADD CONSTRAINT [FK_TPolicyLoan_RefLoanTypeId_RefLoanTypeId] FOREIGN KEY ([RefLoanTypeId]) REFERENCES [dbo].[TRefLoanType] ([RefLoanTypeId])
GO
