CREATE TABLE [dbo].[TFee2PolicyFund]
(
[Fee2PolicyFundId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NULL,
[PolicyBusinessId] [int] NULL,
[Rate] [float] NULL,
[RefValuationBasisId] [int] NULL,
[ValuationStartDate] [datetime] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TFee2PolicyFund_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFee2PolicyFund] ADD CONSTRAINT [PK_TFee2PolicyFund] PRIMARY KEY NONCLUSTERED  ([Fee2PolicyFundId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFee2PolicyFund_FeeId] ON [dbo].[TFee2PolicyFund] ([FeeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFee2PolicyFund_PolicyBusinessId] ON [dbo].[TFee2PolicyFund] ([PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFee2PolicyFund_RefValuationBasisId] ON [dbo].[TFee2PolicyFund] ([RefValuationBasisId])
GO
ALTER TABLE [dbo].[TFee2PolicyFund] ADD CONSTRAINT [FK_TFee2PolicyFund_FeeId_FeeId] FOREIGN KEY ([FeeId]) REFERENCES [dbo].[TFee] ([FeeId])
GO
ALTER TABLE [dbo].[TFee2PolicyFund] WITH CHECK ADD CONSTRAINT [FK_TFee2PolicyFund_PolicyBusinessId_PolicyBusinessId] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TFee2PolicyFund] ADD CONSTRAINT [FK_TFee2PolicyFund_RefValuationBasisId_RefValuationBasisId] FOREIGN KEY ([RefValuationBasisId]) REFERENCES [dbo].[TRefValuationBasis] ([RefValuationBasisId])
GO
