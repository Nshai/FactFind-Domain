CREATE TABLE [dbo].[TFeeModelTemplateToDiscount]
(
[FeeModelTemplateToDiscountId] [int] NOT NULL IDENTITY(1, 1),
[FeeModelTemplateId] [int] NOT NULL,
[DiscountId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TFeeModelTemplateToDiscount] ADD CONSTRAINT [PK_TFeeModelTemplateToDiscount] PRIMARY KEY CLUSTERED  ([FeeModelTemplateToDiscountId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeModelTemplateToDiscount_FeeModelTemplateId] ON [dbo].[TFeeModelTemplateToDiscount] ([FeeModelTemplateId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeModelTemplateToDiscount_TenantId] ON [dbo].[TFeeModelTemplateToDiscount] ([TenantId])
GO
ALTER TABLE [dbo].[TFeeModelTemplateToDiscount] ADD CONSTRAINT [FK_TFeeModelTemplateToDiscount_TDiscount] FOREIGN KEY ([DiscountId]) REFERENCES [dbo].[TDiscount] ([DiscountId]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TFeeModelTemplateToDiscount] ADD CONSTRAINT [FK_TFeeModelTemplateToDiscount_TFeeModelTemplate] FOREIGN KEY ([FeeModelTemplateId]) REFERENCES [dbo].[TFeeModelTemplate] ([FeeModelTemplateId]) ON DELETE CASCADE
GO
