CREATE TABLE [dbo].[TFeeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
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
[SequentialRef] [varchar] (50)  NULL,
[IndigoClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TFeeAudit_ConcurrencyId] DEFAULT ((1)),
[FeeId] [int] NOT NULL,
[StampAction] [char] (1)  NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFeeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255)  NULL,
[AdviseFeeTypeId] [int] NULL,
[AdvisePaymentTypeId] [int] NULL,
[AdviseFeeChargingDetailsId] [int] NULL,
[DiscountId] [int] NULL,
[DiscountReason] [nvarchar] (255)  NULL,
[FeeModelTemplateId] [int] NULL,
[RefAdviceContributionTypeId] [int] NULL CONSTRAINT [DF_TFeeAudit_RefAdviceContributionTypeId] DEFAULT ((0)),
[InitialPeriod] [int] NULL,
[RecurringFrequencyId] [int] NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[IsPaidByProvider] [bit] NULL,
[DiscountAuthorizerId] [int] NULL CONSTRAINT [DF_TFeeAudit_DiscountAuthorizerId] DEFAULT ((0)),
[RefFeeAdviseTypeId] [int] NULL,
[FeePercentage] [decimal] (5, 2) NULL,
[IsFeeEnded] [bit] NULL CONSTRAINT [DF_TFeeAudit_IsFeeEnded] DEFAULT ((0)),
[IsConsultancyFee] [bit] NULL,
[MigrationRef] [varchar] (255)  NULL,
[DiscountAmount] [money] NULL,
[DiscountPercentage] [money] NULL,
[WIPPercentage] [decimal] (5, 2) NULL,
[AmountEarned] [money] NULL,
[ForwardIncomeToAdviserId] [int] NULL,
[ForwardIncomeToUseAdviserBanding] [bit] NULL,
[IsRetainer] [bit] NULL,
[SequentialRefLegacy] [varchar] (50) NULL,
[MinimumFee]  [decimal] (15, 2) NULL,
[MaximumFee]  [decimal] (15, 2) NULL,
[MinimumFeePercentage]  [decimal] (15, 2) NULL,
[MaximumFeePercentage]  [decimal] (15, 2) NULL,
[FeeCode] [nvarchar] (25) NULL
)
GO
ALTER TABLE [dbo].[TFeeAudit] ADD CONSTRAINT [PK_TFeeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TFeeAudit_FeeId_ConcurrencyId] ON [dbo].[TFeeAudit] ([FeeId], [ConcurrencyId])
GO
CREATE NONCLUSTERED INDEX [TFeeAudit_FeeModelTemplateId] ON [dbo].[TFeeAudit] ([FeeModelTemplateId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFeeAudit_StampDateTime] ON [dbo].[TFeeAudit] ([StampDateTime],[IndigoClientId]) INCLUDE ([FeeId],[StampAction])
GO