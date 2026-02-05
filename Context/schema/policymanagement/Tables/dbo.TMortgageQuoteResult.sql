CREATE TABLE [dbo].[TMortgageQuoteResult]
(
[MortgageQuoteResultId] [int] NOT NULL IDENTITY(1, 1),
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
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageQuoteResult_ConcurrencyId] DEFAULT ((1)),
[DurationDescription] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Position] [int] NULL,
[HasKfi] [bit] NULL
)
GO
ALTER TABLE [dbo].[TMortgageQuoteResult] ADD CONSTRAINT [PK_TMortgageQuoteResult] PRIMARY KEY NONCLUSTERED  ([MortgageQuoteResultId])
GO
ALTER TABLE [dbo].[TMortgageQuoteResult] ADD CONSTRAINT [FK_TMortgageQuoteResult_QuoteItemId_TQuoteItem] FOREIGN KEY ([QuoteItemId]) REFERENCES [dbo].[TQuoteItem] ([QuoteItemId])
GO
