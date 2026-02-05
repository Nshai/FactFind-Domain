CREATE TABLE [dbo].[TRefPaymentEventTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PaymentEventTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefPaymentEventTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefPaymen_StampDateTime_1__63] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefPaymentEventTypeAudit] ADD CONSTRAINT [PK_TRefPaymentEventTypeAudit_2__63] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefPaymentEventTypeAudit_RefPaymentEventTypeId_ConcurrencyId] ON [dbo].[TRefPaymentEventTypeAudit] ([RefPaymentEventTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
