CREATE TABLE [dbo].[TQuotePensionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteItemId] [int] NOT NULL,
[Contribution] [decimal] (18, 0) NULL,
[EmployerContribution] [decimal] (18, 0) NULL,
[RetirementAge] [int] NULL,
[TotalFundValue] [decimal] (18, 0) NULL,
[Pension] [decimal] (18, 0) NULL,
[CashSum] [decimal] (18, 0) NULL,
[ReducedPension] [decimal] (18, 0) NULL,
[MediumGrowthRate] [decimal] (18, 0) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuotePensionAudit_ConcurrencyId] DEFAULT ((1)),
[QuotePensionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQuotePensionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQuotePensionAudit] ADD CONSTRAINT [PK_TQuotePensionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQuotePensionAudit_QuotePensionId_ConcurrencyId] ON [dbo].[TQuotePensionAudit] ([QuotePensionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
