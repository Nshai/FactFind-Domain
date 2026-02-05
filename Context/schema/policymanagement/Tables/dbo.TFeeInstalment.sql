CREATE TABLE [dbo].[TFeeInstalment]
(
[FeeInstalmentId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NOT NULL,
[NextInstalmentDate] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeeInstalment_ConcurrencyId] DEFAULT ((1)),
[InstalmentCount] [int] NOT NULL CONSTRAINT [Df_InstalmentCount] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TFeeInstalment] ADD CONSTRAINT [PK_TFeeInstalment] PRIMARY KEY CLUSTERED  ([FeeInstalmentId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeInstalment] ON [dbo].[TFeeInstalment] ([FeeId])
GO
ALTER TABLE [dbo].[TFeeInstalment] ADD CONSTRAINT [FK_TFeeInstalment_TFee] FOREIGN KEY ([FeeId]) REFERENCES [dbo].[TFee] ([FeeId])
GO
