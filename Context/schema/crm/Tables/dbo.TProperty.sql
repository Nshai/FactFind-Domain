CREATE TABLE [dbo].[TProperty]
(
[PropertyId] [int] NOT NULL IDENTITY(1, 1),
[Tenancy] [varchar] (32)  NOT NULL,
[Amount] [money] NULL,
[PurchasedOn] [datetime] NULL,
[MortgageAmount] [money] NULL,
[LoanType] [varchar] (32)  NULL,
[StartedOn] [datetime] NULL,
[EndsOn] [datetime] NULL,
[Description] [varchar] (32)  NULL,
[CurrentValue] [money] NULL,
[InsuredBuildings] [bit] NULL CONSTRAINT [DF_TProperty_InsuredBuildings] DEFAULT ((0)),
[InsuredContents] [bit] NULL CONSTRAINT [DF_TProperty_InsuredContents] DEFAULT ((0)),
[Lender] [varchar] (32)  NULL,
[OriginalTerm] [int] NULL,
[Balance] [money] NULL,
[Details] [varchar] (255)  NULL,
[MonthlyRepayments] [money] NULL,
[InterestRate] [money] NULL,
[Death] [bit] NULL,
[Sickness] [bit] NULL,
[Unemployment] [bit] NULL,
[ElectoralRoll] [bit] NULL CONSTRAINT [DF_TProperty_ElectoralRoll] DEFAULT ((0)),
[CrmContactId] [int] NOT NULL,
[MortgageType] [varchar] (32)  NULL,
[FeatureExpires] [datetime] NULL,
[RedemptionPenalty] [bit] NULL,
[RedemptionPenaltyExpiryDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProperty_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TProperty] ADD CONSTRAINT [PK_TProperty_PropertyId] PRIMARY KEY CLUSTERED  ([PropertyId])
GO
ALTER TABLE [dbo].[TProperty] WITH CHECK ADD CONSTRAINT [FK_TProperty_CrmContactId_CrmContactId] FOREIGN KEY ([CrmContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
