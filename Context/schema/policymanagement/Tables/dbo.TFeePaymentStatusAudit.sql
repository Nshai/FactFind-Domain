CREATE TABLE [dbo].[TFeePaymentStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[FeeId] [int] NOT NULL,
[PaymentStatus] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[PaymentStatusNotes] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[PaymentStatusDate] [datetime] NOT NULL,
[UpdatedUserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeePaymen_ConcurrencyId_1__56] DEFAULT ((1)),
[FeePaymentStatusId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFeePaymen_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFeePaymentStatusAudit] ADD CONSTRAINT [PK_TFeePaymentStatusAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TFeePaymentStatusAudit_FeePaymentStatusId_ConcurrencyId] ON [dbo].[TFeePaymentStatusAudit] ([FeePaymentStatusId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
