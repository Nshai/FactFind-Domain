CREATE TABLE [dbo].[TFeeModelTemplateToAdvisePaymentType]
(
[FeeModelTemplateToAdvisePaymentTypeId] [int] NOT NULL IDENTITY(1, 1),
[FeeModelTemplateId] [int] NOT NULL,
[AdvisePaymentTypeId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeeModelTemplateToAdvisePaymentType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFeeModelTemplateToAdvisePaymentType] ADD CONSTRAINT [PK_TFeeModelTemplateToAdvisePaymentType] PRIMARY KEY CLUSTERED  ([FeeModelTemplateToAdvisePaymentTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeModelTemplateToAdvisePaymentType_FeeModelTemplateId] ON [dbo].[TFeeModelTemplateToAdvisePaymentType] ([FeeModelTemplateId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeModelTemplateToAdvisePaymentType_TenantId] ON [dbo].[TFeeModelTemplateToAdvisePaymentType] ([TenantId])
GO
ALTER TABLE [dbo].[TFeeModelTemplateToAdvisePaymentType] ADD CONSTRAINT [FK_TFeeModelTemplateToAdvisePaymentType_TAdvisePaymentType] FOREIGN KEY ([AdvisePaymentTypeId]) REFERENCES [dbo].[TAdvisePaymentType] ([AdvisePaymentTypeId])
GO
ALTER TABLE [dbo].[TFeeModelTemplateToAdvisePaymentType] ADD CONSTRAINT [FK_TFeeModelTemplateToAdvisePaymentType_TFeeModelTemplate] FOREIGN KEY ([FeeModelTemplateId]) REFERENCES [dbo].[TFeeModelTemplate] ([FeeModelTemplateId]) ON DELETE CASCADE
GO
