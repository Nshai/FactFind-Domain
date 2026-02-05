CREATE TABLE [dbo].[TFeeModelTemplateAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[FeeModelId] [int] NOT NULL,
[AdviseFeeTypeId] [int] NULL,
[AdviseFeeChargingDetailsId] [int] NULL,
[FeeAmount] [decimal] (18, 2) NULL,
[IsDefault] [bit] NULL,
[VATAmount] [decimal] (18, 2) NULL,
[IsVATExcempt] [bit] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[FeeModelTemplateId] [int] NOT NULL,
[RecurringFrequencyId] [int] NULL,
[InstalmentsFrequencyId] [int] NULL,
[RefVATId] [int] NULL,
[InitialPeriod] [int] NULL,
[IsInstalments] [bit] NULL,
[IsPaidByProvider] [bit] NULL CONSTRAINT [DF_TFeeModelTemplateAudit_IsPaidByProvider] DEFAULT ((0)),
[NumRecurringPayments] [int] NULL,
[RefAdviceContributionTypeId] [int] NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[RefFeeAdviseTypeId] [int] NULL,
[FeePercentage] [decimal] (5, 2) NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IsConsultancyFee] [bit] NULL,
[ServiceStatusId] [int] NULL,
[IsRetainer] [bit] NULL,
[FeeCode] [nvarchar] (25) NULL
)
GO
ALTER TABLE [dbo].[TFeeModelTemplateAudit] ADD CONSTRAINT [PK_TFeeModelTemplateAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
