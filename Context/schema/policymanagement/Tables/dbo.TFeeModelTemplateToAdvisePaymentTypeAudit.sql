CREATE TABLE [dbo].[TFeeModelTemplateToAdvisePaymentTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FeeModelTemplateId] [int] NOT NULL,
[AdvisePaymentTypeId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[FeeModelTemplateToAdvisePaymentTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFeeModelTemplateToAdvisePaymentTypeAudit] ADD CONSTRAINT [PK_TFeeModelTemplateToAdvisePaymentTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
