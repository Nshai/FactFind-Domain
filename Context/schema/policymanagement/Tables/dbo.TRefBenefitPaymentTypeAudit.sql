CREATE TABLE [dbo].[TRefBenefitPaymentTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[BenefitTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrigoRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefBenefitPaymentTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefBenefi_StampDateTime_1__52] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefBenefitPaymentTypeAudit] ADD CONSTRAINT [PK_TRefBenefitPaymentTypeAudit_2__52] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefBenefitPaymentTypeAudit_RefBenefitPaymentTypeId_ConcurrencyId] ON [dbo].[TRefBenefitPaymentTypeAudit] ([RefBenefitPaymentTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
