CREATE TABLE [dbo].[TQuoteClient]
(
[QuoteClientId] [int] NOT NULL IDENTITY(1, 1),
[ClientPartyId] [int] NOT NULL,
[RefOccupationId] [int] NULL,
[TaxRate] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
[EmployerName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuoteClient] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TQuoteClient] ADD CONSTRAINT [PK_TQuoteClient] PRIMARY KEY CLUSTERED  ([QuoteClientId])
GO
CREATE NONCLUSTERED INDEX [IX_TQuoteClient_ClientPartyId] ON [dbo].[TQuoteClient] ([ClientPartyId])
GO
