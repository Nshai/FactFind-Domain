CREATE TABLE [dbo].[TQuotePHIAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteItemId] [int] NOT NULL,
[Premium] [decimal] (10, 2) NULL,
[PremiumIncrease] [decimal] (10, 2) NULL,
[CoverPeriod] [int] NULL,
[DeferredPeriod] [int] NULL,
[Benefit] [decimal] (10, 2) NULL,
[Salary] [decimal] (10, 2) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuotePHIAudit_ConcurrencyId] DEFAULT ((1)),
[QuotePHIId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQuotePHIAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQuotePHIAudit] ADD CONSTRAINT [PK_TQuotePHIAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQuotePHIAudit_QuotePHIId_ConcurrencyId] ON [dbo].[TQuotePHIAudit] ([QuotePHIId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
