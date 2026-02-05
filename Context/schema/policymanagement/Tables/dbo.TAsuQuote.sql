CREATE TABLE [dbo].[TAsuQuote]
(
[QuoteId] [int] NOT NULL,
[UnemploymentWait] [int] NULL,
[DisabilityWait] [int] NULL,
[UnemploymentWaitType] [int] NULL,
[DisabilityWaitType] [int] NULL,
[CoverType] [int] NULL,
[PolicyBenefitPeriod] [int] NULL,
[BenefitUplift] [int] NULL,
[DeferrePremiumLength] [int] NULL,
[TotalBenefit] [decimal] (10, 4) NULL,
[MonthlyMortgagePayment] [decimal] (10, 4) NULL,
[OtherCover] [decimal] (10, 4) NULL,
[Customer1Benefit] [decimal] (10, 4) NULL,
[BenefitUpliftAmount] [decimal] (10, 4) NULL,
[ProductToQuote] [nvarchar] (200) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TAsuQuote_ConcurrencyId] DEFAULT ((1)),
[HasArrangedMortgage] [int] NULL
)
GO
ALTER TABLE [dbo].[TAsuQuote] ADD CONSTRAINT [PK_TAsuQuote] PRIMARY KEY CLUSTERED  ([QuoteId])
GO
