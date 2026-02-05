CREATE TABLE [dbo].[TPropertyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Tenancy] [varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL,
[Amount] [money] NOT NULL,
[PurchasedOn] [datetime] NULL,
[MortgageAmount] [money] NULL,
[LoanType] [varchar] (32) COLLATE Latin1_General_CI_AS NULL,
[StartedOn] [datetime] NULL,
[EndsOn] [datetime] NULL,
[Description] [varchar] (32) COLLATE Latin1_General_CI_AS NULL,
[CurrentValue] [money] NULL,
[InsuredBuildings] [bit] NULL CONSTRAINT [DF_TPropertyAudit_InsuredBuildings] DEFAULT ((0)),
[InsuredContents] [bit] NULL CONSTRAINT [DF_TPropertyAudit_InsuredContents] DEFAULT ((0)),
[Lender] [varchar] (32) COLLATE Latin1_General_CI_AS NULL,
[OriginalTerm] [int] NULL,
[Balance] [money] NULL,
[Details] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MonthlyRepayments] [money] NULL,
[InterestRate] [decimal] (18, 0) NULL,
[Death] [bit] NULL,
[Sickness] [bit] NULL,
[Unemployment] [bit] NULL,
[ElectoralRoll] [bit] NULL CONSTRAINT [DF_TPropertyAudit_ElectoralRoll] DEFAULT ((0)),
[CrmContactId] [int] NOT NULL,
[MortgageType] [varchar] (32) COLLATE Latin1_General_CI_AS NULL,
[FeatureExpires] [datetime] NULL,
[RedemptionPenalty] [bit] NULL,
[RedemptionPenaltyExpiryDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL,
[PropertyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPropertyAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPropertyAudit] ADD CONSTRAINT [PK_TPropertyAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPropertyAudit_PropertyId_ConcurrencyId] ON [dbo].[TPropertyAudit] ([PropertyId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
