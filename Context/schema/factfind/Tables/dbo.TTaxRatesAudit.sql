CREATE TABLE [dbo].[TTaxRatesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TaxRate] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[TaxRatesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TTaxRates__Concu__644DCFC1] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTaxRatesAudit] ADD CONSTRAINT [PK_TTaxRatesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
