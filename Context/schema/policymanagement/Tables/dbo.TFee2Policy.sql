CREATE TABLE [dbo].[TFee2Policy]
(
[Fee2PolicyId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NULL,
[PolicyBusinessId] [int] NULL,
[RebateCommission] [bit] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TFee2Policy_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFee2Policy] ADD CONSTRAINT [PK_TFee2Policy] PRIMARY KEY CLUSTERED  ([Fee2PolicyId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFee2Policy_FeeId] ON [dbo].[TFee2Policy] ([FeeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFee2Policy_PolicyBusinessId] ON [dbo].[TFee2Policy] ([PolicyBusinessId]) include (FeeId)
GO
ALTER TABLE [dbo].[TFee2Policy] ADD CONSTRAINT [FK_TFee2Policy_FeeId_FeeId] FOREIGN KEY ([FeeId]) REFERENCES [dbo].[TFee] ([FeeId])
GO
ALTER TABLE [dbo].[TFee2Policy] ADD CONSTRAINT [UQ_FeeId_PolicyBusinessId] UNIQUE ([FeeId], [PolicyBusinessId])
GO
