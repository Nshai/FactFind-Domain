CREATE TABLE [dbo].[TFeeRetainerVAT]
(
[FeeRetainerVATId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NULL,
[RetainerId] [int] NULL,
[RefVATId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeeRetainerVAT_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFeeRetainerVAT] ADD CONSTRAINT [PK_TFeeRetainerVAT] PRIMARY KEY NONCLUSTERED  ([FeeRetainerVATId])
GO
