CREATE TABLE [dbo].[TFeeTiering]
(
[FeeTieringId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[FeeId] [int] NOT NULL,
[Threshold] [decimal] (18, 2) NULL,
[Percentage] [decimal] (5, 2) NOT NULL,
[TenantId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeeTiering_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFeeTiering] ADD CONSTRAINT [PK_TFeeTiering] PRIMARY KEY CLUSTERED  ([FeeTieringId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeTiering_TenantId] ON [dbo].[TFeeTiering] ([TenantId])
GO
ALTER TABLE [dbo].[TFeeTiering] ADD CONSTRAINT [FK_TFeeTiering_TFee] FOREIGN KEY ([FeeId]) REFERENCES [dbo].[TFee] ([FeeId])
GO
