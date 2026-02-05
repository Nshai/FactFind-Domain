CREATE TABLE [dbo].[TExpectationsTracker]
(
[ExpectationsTrackerId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[FeeId] [int] NOT NULL,
[CalculatedOnAmount] [int] NOT NULL,
[FeePercentage] [numeric] (18, 2) NULL,
[VATPercentage] [numeric] (18, 2) NULL,
[IsVATExempt] [bit] NULL,
[DiscountPercentage] [numeric] (18, 2) NULL,
[Net Amount] [numeric] (18, 2) NULL,
[VAT Amount] [numeric] (18, 2) NULL,
[DiscountAmount] [numeric] (18, 2) NULL,
[Total Amount] [numeric] (18, 2) NULL,
[CreatedDate] [datetime] NULL
)
GO
