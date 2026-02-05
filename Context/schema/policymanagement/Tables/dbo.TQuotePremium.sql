CREATE TABLE [dbo].[TQuotePremium]
(
[QuotePremiumId] [int] NOT NULL IDENTITY(1, 1),
[Frequency] [int] NULL,
[Type] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuotePremium_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQuotePremium] ADD CONSTRAINT [PK_TQuotePremium] PRIMARY KEY CLUSTERED  ([QuotePremiumId])
GO
