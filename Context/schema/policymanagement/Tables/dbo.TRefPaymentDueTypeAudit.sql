CREATE TABLE [dbo].[TRefPaymentDueTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PaymentDueType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefLicenseTypeId] [int] NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefPaymentDueTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefPaymen_StampDateTime_3__52] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefPaymentDueTypeAudit] ADD CONSTRAINT [PK_TRefPaymentDueTypeAudit_4__52] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefPaymentDueTypeAudit_RefPaymentDueTypeId_ConcurrencyId] ON [dbo].[TRefPaymentDueTypeAudit] ([RefPaymentDueTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
