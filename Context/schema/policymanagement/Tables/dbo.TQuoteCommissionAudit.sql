CREATE TABLE [dbo].[TQuoteCommissionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[InitialPercentage] [decimal] (5, 2) NOT NULL,
[RenewalPercentage] [decimal] (5, 2) NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[QuoteCommissionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQuoteCommissionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQuoteCommissionAudit] ADD CONSTRAINT [PK_TQuoteCommissionAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
