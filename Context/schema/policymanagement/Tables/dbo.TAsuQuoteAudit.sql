CREATE TABLE [dbo].[TAsuQuoteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAsuQuoteAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[QuoteId] [int] NULL,
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
[ProductToQuote] [varchar] (400) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL,
[HasArrangedMortgage] [int] NULL
)
GO
ALTER TABLE [dbo].[TAsuQuoteAudit] ADD CONSTRAINT [PK_TAsuQuoteAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
