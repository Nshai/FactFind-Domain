CREATE TABLE [dbo].[TFeeModelTemplateToPlanType]
(
[FeeModelTemplateToPlanTypeId] [int] NOT NULL IDENTITY(1, 1),
[FeeModelTemplateId] [int] NOT NULL,
[RefPlanTypeId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeeModelTemplateToPlanType_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TFeeModelTemplateToPlanType] ADD CONSTRAINT [PK_TFeeModelTemplateToPlanType] PRIMARY KEY CLUSTERED  ([FeeModelTemplateToPlanTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeModelTemplateToPlanType_FeeModelTemplateId] ON [dbo].[TFeeModelTemplateToPlanType] ([FeeModelTemplateId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeModelTemplateToPlanType_TenantId] ON [dbo].[TFeeModelTemplateToPlanType] ([TenantId])
GO
ALTER TABLE [dbo].[TFeeModelTemplateToPlanType] ADD CONSTRAINT [FK_TFeeModelTemplateToPlanType_TFeeModelTemplate] FOREIGN KEY ([FeeModelTemplateId]) REFERENCES [dbo].[TFeeModelTemplate] ([FeeModelTemplateId]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TFeeModelTemplateToPlanType] ADD CONSTRAINT [FK_TFeeModelTemplateToPlanType_TRefPlanType] FOREIGN KEY ([RefPlanTypeId]) REFERENCES [dbo].[TRefPlanType] ([RefPlanTypeId]) ON DELETE CASCADE
GO
