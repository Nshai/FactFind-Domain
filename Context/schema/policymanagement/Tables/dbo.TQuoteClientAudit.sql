CREATE TABLE [dbo].[TQuoteClientAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ClientPartyId] [int] NOT NULL,
[RefOccupationId] [int] NULL,
[TaxRate] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
[EmployerName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[QuoteClientId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQuoteClientAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQuoteClientAudit] ADD CONSTRAINT [PK_TQuoteClientAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
