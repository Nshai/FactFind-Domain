CREATE TABLE [dbo].[TMortgageQuoteResultAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteItemId] [int] NOT NULL,
[InitialMonthlyAmount] [money] NULL,
[InitialInterestRate] [decimal] (10, 2) NULL,
[ReviosnaryRate] [decimal] (10, 2) NULL,
[ProductType] [varchar] (32) COLLATE Latin1_General_CI_AS NULL,
[Duration] [int] NULL,
[EarlyRepaymentCharge] [decimal] (10, 2) NULL,
[TrueCostofMortgage] [decimal] (10, 2) NULL,
[TrueCostTerm] [int] NULL,
[BookingFeeAmount] [decimal] (10, 2) NULL,
[CompletionFeeAmount] [decimal] (10, 2) NULL,
[HLCAmount] [decimal] (10, 2) NULL,
[LenderName] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MortgageQuoteSummaryId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageQuoteResultAudit_ConcurrencyId] DEFAULT ((1)),
[MortgageQuoteResultId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TMortgageQuoteResultAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[DurationDescription] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Position] [int] NULL,
[HasKfi] [bit] NULL
)
GO
ALTER TABLE [dbo].[TMortgageQuoteResultAudit] ADD CONSTRAINT [PK_TMortgageQuoteResultAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
