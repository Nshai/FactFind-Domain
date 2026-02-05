CREATE TABLE [dbo].[TFee]
(
[FeeId] [int] NOT NULL IDENTITY(1, 1),
[RefFeeTypeId] [int] NOT NULL,
[NetAmount] [money] NULL,
[VATAmount] [money] NULL,
[InvoiceDate] [datetime] NULL,
[SentToClientDate] [datetime] NULL,
[NextDueDate] [datetime] NULL,
[BillingPeriodMonths] [tinyint] NULL,
[VATExempt] [bit] NULL,
[RefVATId] [int] NULL,
[Description] [nvarchar] (1000)  NULL,
[IsRecurring] [bit] NULL,
[RefFeeRetainerFrequencyId] [int] NULL,
[NumRecurringPayments] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[SequentialRefLegacy] [varchar] (50)  NULL,
[SequentialRef]  AS (case when [SequentialRefLegacy] IS NULL then 'IOF'+right(replicate('0',(8))+CONVERT([varchar],[FeeId]),(8))  else [SequentialRefLegacy] end),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TFee_ConcurrencyId] DEFAULT ((1)),
[AdviseFeeTypeId] [int] NULL,
[AdvisePaymentTypeId] [int] NULL,
[AdviseFeeChargingDetailsId] [int] NULL,
[DiscountId] [int] NULL,
[DiscountReason] [nvarchar] (255)  NULL,
[FeeModelTemplateId] [int] NULL,
[RefAdviceContributionTypeId] [int] NULL CONSTRAINT [DF_TFee_RefAdviceContributionTypeId] DEFAULT ((0)),
[InitialPeriod] [int] NULL,
[RecurringFrequencyId] [int] NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[IsPaidByProvider] [bit] NULL CONSTRAINT [DF_TFee_IsPaidByProvider] DEFAULT ((0)),
[DiscountAuthorizerId] [int] NULL CONSTRAINT [DF_TFee_DiscountAuthorizerId] DEFAULT ((0)),
[RefFeeAdviseTypeId] [int] NULL,
[FeePercentage] [decimal] (5, 2) NULL,
[IsFeeEnded] [bit] NULL CONSTRAINT [DF_TFee_IsFeeEnded] DEFAULT ((0)),
[IsConsultancyFee] [bit] NULL CONSTRAINT [DF_TFee_IsConsultancyFee] DEFAULT ((0)),
[MigrationRef] [varchar] (255)  NULL,
[DiscountAmount] [money] NULL,
[DiscountPercentage] [money] NULL,
[WIPPercentage] [decimal] (5, 2) NULL,
[AmountEarned]  [money] NULL,
[MinimumFee]  [decimal] (15, 2) NULL,
[MaximumFee]  [decimal] (15, 2) NULL,
[MinimumFeePercentage]  [decimal] (15, 2) NULL,
[MaximumFeePercentage]  [decimal] (15, 2) NULL,
[ForwardIncomeToAdviserId] [int] NULL,
[ForwardIncomeToUseAdviserBanding] [bit] NULL,
[IsRetainer] [bit] NULL,
[FeeCode] [nvarchar] (25) NULL
)
GO
ALTER TABLE [dbo].[TFee] ADD CONSTRAINT [PK_TFee] PRIMARY KEY CLUSTERED  ([FeeId])
GO
CREATE NONCLUSTERED INDEX [TFee_FeeModelTemplateId] ON [dbo].[TFee] ([FeeModelTemplateId])
GO
CREATE NONCLUSTERED INDEX [IX_TFee_IndigoClientId] ON [dbo].[TFee] ([IndigoClientId]) INCLUDE ([AdviseFeeChargingDetailsId], [AdviseFeeTypeId], [AdvisePaymentTypeId], [FeeId], [FeePercentage], [InvoiceDate], [NetAmount], [VATAmount], [VATExempt])
GO
CREATE NONCLUSTERED INDEX [IDX_TFee_RefFeeTypeId] ON [dbo].[TFee] ([RefFeeTypeId])
GO
ALTER TABLE [dbo].[TFee] ADD CONSTRAINT [FK_TFee_TAdviseFeeChargingDetails] FOREIGN KEY ([AdviseFeeChargingDetailsId]) REFERENCES [dbo].[TAdviseFeeChargingDetails] ([AdviseFeeChargingDetailsId])
GO
ALTER TABLE [dbo].[TFee] ADD CONSTRAINT [FK_TFee_TAdviseFeeType] FOREIGN KEY ([AdviseFeeTypeId]) REFERENCES [dbo].[TAdviseFeeType] ([AdviseFeeTypeId])
GO
ALTER TABLE [dbo].[TFee] ADD CONSTRAINT [FK_TFee_TAdvisePaymentType] FOREIGN KEY ([AdvisePaymentTypeId]) REFERENCES [dbo].[TAdvisePaymentType] ([AdvisePaymentTypeId])
GO
ALTER TABLE [dbo].[TFee] ADD CONSTRAINT [FK_TFee_RefFeeTypeId_RefFeeTypeId] FOREIGN KEY ([RefFeeTypeId]) REFERENCES [dbo].[TRefFeeType] ([RefFeeTypeId])
GO
create index IX_TFee_FeeID on TFee (FeeId) include (AdviseFeeTypeId, AdvisePaymentTypeId)
GO
CREATE NONCLUSTERED INDEX [IDX_TFee_IndigoClientId_SentToClientDate] ON [dbo].[TFee] ([IndigoClientId],[SentToClientDate]) INCLUDE ([FeeId],[AdviseFeeTypeId],[AdvisePaymentTypeId])
GO 