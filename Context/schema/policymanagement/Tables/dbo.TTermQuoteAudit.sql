CREATE TABLE [dbo].[TTermQuoteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[ProductTermId] [int] NULL,
[QuotationBasisId] [int] NULL,
[QuotePremiumId] [int] NULL,
[LivesAssuredBasis] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IncludeRenewable] [bit] NULL,
[IncludeBusinessProtectionLevel] [bit] NULL,
[IncludeBusinessProtectionDecreasing] [bit] NULL,
[MortgageInterestRate] [decimal] (5, 2) NOT NULL,
[PolicyInterestRate] [decimal] (5, 2) NOT NULL,
[PremiumWaiverRequired] [bit] NOT NULL,
[IncludeTerminalIllness] [bit] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[TermQuoteId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TTermQuoteAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTermQuoteAudit] ADD CONSTRAINT [PK_TTermQuoteAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
