CREATE TABLE [dbo].[TPolicyLoanAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
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
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyLoa_ConcurrencyId_1__56] DEFAULT ((1)),
[PolicyLoanId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyLoa_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPolicyLoanAudit] ADD CONSTRAINT [PK_TPolicyLoanAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPolicyLoanAudit_PolicyLoanId_ConcurrencyId] ON [dbo].[TPolicyLoanAudit] ([PolicyLoanId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
