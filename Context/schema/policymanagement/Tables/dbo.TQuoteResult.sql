CREATE TABLE [dbo].[TQuoteResult]
(
[QuoteResultId] [int] NOT NULL IDENTITY(1, 1),
[RefProductTypeId] [int] NOT NULL,
[QuoteId] [int] NOT NULL,
[QuoteItemId] [int] NULL,
[QuoteReference] [varchar] (64)  NOT NULL,
[QuoteDate] [datetime] NOT NULL CONSTRAINT [DF_TQuoteResult_QuoteDate] DEFAULT (getdate()),
[ProductReferenceNumber] [varchar] (56)  NULL,
[PSLProductRefNo] [varchar] (64)  NULL,
[TenantId] [int] NOT NULL,
[PolicyFeeExcIPT] [smallmoney] NULL,
[InsurancePremiumTax] [smallmoney] NULL,
[AnnualIPT] [smallmoney] NULL,
[AnnualPremium] [smallmoney] NULL,
[AnnualPremiumExcIPT] [smallmoney] NULL,
[TotalMonthlyCost] [smallmoney] NULL,
[TotalMonthlyCostExcIPT] [smallmoney] NULL,
[MonthlyPremium] [smallmoney] NULL,
[MonthlyPremiumExcIpt] [smallmoney] NULL,
[TotalPremium] [smallmoney] NULL,
[TotalPremiumExcIPT] [smallmoney] NULL,
[InsurerName] [varchar] (128)  NULL,
[InsurerCode] [varchar] (64)  NULL,
[PolicyFee] [smallmoney] NULL,
[InitialExclusionPeriod] [int] NULL,
[IEPWaivedBenefit] [smallmoney] NULL,
[IEPAppliedBenefit] [smallmoney] NULL,
[IsReferred] [bit] NULL,
[FiveYearPremium] [smallmoney] NULL,
[CreditorInsurerName] [varchar] (128)  NULL,
[Customer1Premium] [smallmoney] NULL,
[Customer2Premium] [smallmoney] NULL,
[BuildingsContentsPremium] [smallmoney] NULL,
[BuildingsContentsPremiumExcIPT] [smallmoney] NULL,
[BuildingsPremium] [smallmoney] NULL,
[BuildingsPremiumExcIPT] [smallmoney] NULL,
[ContentsPremium] [smallmoney] NULL,
[ContentsPremiumExcIPT] [smallmoney] NULL,
[HomeEmergencyPremium] [smallmoney] NULL,
[HomeEmergencyPremiumExcIPT] [smallmoney] NULL,
[LegalCoverInsurerName] [varchar] (128)  NULL,
[LegalCoverInsurerCode] [varchar] (64)  NULL,
[LegalCoverPremium] [smallmoney] NULL,
[LegalCoverPremiumExcIPT] [smallmoney] NULL,
[HouseholdInsurerName] [varchar] (128)  NULL,
[HouseholdInsurerCode] [varchar] (64)  NULL,
[HomeEmergencyInsurerName] [varchar] (128)  NULL,
[HomeEmergencyInsurerCode] [varchar] (64)  NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuoteResult_ConcurrencyId] DEFAULT ((1)),
[QuoteSystemProductType] [varchar] (64)  NULL,
[QuoteResultInternal] [xml] NULL,
[IsMarked] [bit] NULL,
[ProductDescription] [varchar] (256)  NULL,
[ExpiryDate] [datetime] NULL,
[ProviderName] [varchar] (256)  NULL
)
GO
ALTER TABLE [dbo].[TQuoteResult] ADD CONSTRAINT [PK_TQuoteResult] PRIMARY KEY CLUSTERED  ([QuoteResultId])
GO
CREATE NONCLUSTERED INDEX [IX_TQuoteResult_QuoteId] ON [dbo].[TQuoteResult] ([QuoteId])
GO
ALTER TABLE [dbo].[TQuoteResult] WITH CHECK ADD CONSTRAINT [FK_TQuoteResult_TQuote] FOREIGN KEY ([QuoteId]) REFERENCES [dbo].[TQuote] ([QuoteId])
GO
ALTER TABLE [dbo].[TQuoteResult] WITH CHECK ADD CONSTRAINT [FK_TQuoteResult_TQuoteItem] FOREIGN KEY ([QuoteItemId]) REFERENCES [dbo].[TQuoteItem] ([QuoteItemId])
GO
ALTER TABLE [dbo].[TQuoteResult] WITH CHECK ADD CONSTRAINT [FK_TQuoteResult_TRefProductType] FOREIGN KEY ([RefProductTypeId]) REFERENCES [dbo].[TRefProductType] ([RefProductTypeId])
GO
