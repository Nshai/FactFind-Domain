CREATE TABLE [dbo].[TPolicyFund]
(
[PolicyFundId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PolicyBusinessId] [int] NULL CONSTRAINT [DF_TPolicyFun_PolicyDetailsId_4__63] DEFAULT ((0)),
[FundId] [int] NULL CONSTRAINT [DF_TPolicyFun_FundId_2__63] DEFAULT ((0)),
[FundProviderId] [int] NULL,
[RefUnitTypeId] [int] NULL,
[RefPriceBasisId] [int] NULL,
[PurchasePrice] [money] NULL,
[PurchaseDate] [datetime] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyFun_ConcurrencyId_1__63] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPolicyFund] ADD CONSTRAINT [PK_TPolicyFunds_8__63] PRIMARY KEY NONCLUSTERED  ([PolicyFundId]) WITH (FILLFACTOR=80)
GO
