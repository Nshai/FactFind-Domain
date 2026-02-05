CREATE TABLE [dbo].[TProviderQuoteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[RefProductProviderId] [int] NOT NULL,
[ProviderCode] [varchar] (512) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[ProviderQuoteId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProviderQuoteAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProviderQuoteAudit] ADD CONSTRAINT [PK_TProviderQuoteAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
