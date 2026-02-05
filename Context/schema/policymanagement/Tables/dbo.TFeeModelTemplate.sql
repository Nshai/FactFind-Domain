CREATE TABLE [dbo].[TFeeModelTemplate]
(
[FeeModelTemplateId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[FeeModelId] [int] NOT NULL,
[AdviseFeeTypeId] [int] NULL,
[AdviseFeeChargingDetailsId] [int] NULL,
[FeeAmount] [decimal] (18, 2) NULL,
[IsDefault] [bit] NULL CONSTRAINT [DF_TFeeModelTemplate_IsDefault] DEFAULT ((0)),
[VATAmount] [decimal] (18, 2) NULL,
[IsVATExcempt] [bit] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeeModelTemplate_ConcurrencyId] DEFAULT ((1)),
[RecurringFrequencyId] [int] NULL,
[InstalmentsFrequencyId] [int] NULL,
[RefVATId] [int] NULL,
[InitialPeriod] [int] NULL,
[IsInstalments] [bit] NULL CONSTRAINT [DF_TFeeModelTemplate_IsInstalments] DEFAULT ((0)),
[IsPaidByProvider] [bit] NULL CONSTRAINT [DF_TFeeModelTemplate_IsPaidByProvider] DEFAULT ((0)),
[NumRecurringPayments] [int] NULL,
[RefAdviceContributionTypeId] [int] NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[RefFeeAdviseTypeId] [int] NULL,
[FeePercentage] [decimal] (5, 2) NULL,
[IsConsultancyFee] [bit] NULL CONSTRAINT [DF_TFeeModelTemplate_IsConsultancyFee] DEFAULT ((0)),
[ServiceStatusId] [int] NULL,
[IsRetainer] [bit] NULL,
[FeeCode] [nvarchar] (25) NULL
)
GO
ALTER TABLE [dbo].[TFeeModelTemplate] ADD CONSTRAINT [PK_TFeeModelTemplate] PRIMARY KEY CLUSTERED  ([FeeModelTemplateId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeModel_FeeModelId] ON [dbo].[TFeeModelTemplate] ([FeeModelId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeModelTemplate_TenantId] ON [dbo].[TFeeModelTemplate] ([TenantId])
GO
ALTER TABLE [dbo].[TFeeModelTemplate] ADD CONSTRAINT [FK_TFeeModelTemplate_TAdviseFeeChargingDetails] FOREIGN KEY ([AdviseFeeChargingDetailsId]) REFERENCES [dbo].[TAdviseFeeChargingDetails] ([AdviseFeeChargingDetailsId])
GO
ALTER TABLE [dbo].[TFeeModelTemplate] ADD CONSTRAINT [FK_TFeeModelTemplate_TAdviseFeeType] FOREIGN KEY ([AdviseFeeTypeId]) REFERENCES [dbo].[TAdviseFeeType] ([AdviseFeeTypeId])
GO
ALTER TABLE [dbo].[TFeeModelTemplate] ADD CONSTRAINT [FK_TFeeModelTemplate_TFeeModel] FOREIGN KEY ([FeeModelId]) REFERENCES [dbo].[TFeeModel] ([FeeModelId]) ON DELETE CASCADE
GO
