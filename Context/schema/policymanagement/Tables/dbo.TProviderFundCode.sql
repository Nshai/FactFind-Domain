CREATE TABLE [dbo].[TProviderFundCode]
(
[ProviderFundCodeId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NOT NULL,
[ProviderFundCode] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[FundId] [int] NOT NULL,
[FundTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProviderFundCode_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TProviderFundCode] ADD CONSTRAINT [PK_TProviderFundCode] PRIMARY KEY NONCLUSTERED  ([ProviderFundCodeId])
GO
CREATE NONCLUSTERED INDEX [IX_TProviderFundCode_FundId_ProviderFundCode] ON [dbo].[TProviderFundCode] ([FundId], [ProviderFundCode])
GO
CREATE NONCLUSTERED INDEX IX_TProviderFundCode_RefProdProviderId_ProviderFundCode ON [dbo].[TProviderFundCode] ([RefProdProviderId],[ProviderFundCode])
GO