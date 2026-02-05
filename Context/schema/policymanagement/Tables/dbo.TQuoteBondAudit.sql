CREATE TABLE [dbo].[TQuoteBondAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteItemId] [int] NOT NULL,
[InvestmentAmount] [decimal] (10, 2) NULL,
[Term] [int] NULL,
[FinalCIV] [decimal] (10, 2) NULL,
[NumFreeSwitches] [int] NULL,
[MedGrowthRate] [decimal] (10, 2) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuoteBondAudit_ConcurrencyId] DEFAULT ((1)),
[QuoteBondId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQuoteBondAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQuoteBondAudit] ADD CONSTRAINT [PK_TQuoteBondAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQuoteBondAudit_QuoteBondId_ConcurrencyId] ON [dbo].[TQuoteBondAudit] ([QuoteBondId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
