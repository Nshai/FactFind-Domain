CREATE TABLE [dbo].[TRetainerPaymentStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RetainerId] [int] NOT NULL,
[PaymentStatus] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[PaymentStatusNotes] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[PaymentStatusDate] [datetime] NOT NULL,
[UpdatedUserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRetainerP_ConcurrencyId_1__56] DEFAULT ((1)),
[RetainerPaymentStatusId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRetainerP_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRetainerPaymentStatusAudit] ADD CONSTRAINT [PK_TRetainerPaymentStatusAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRetainerPaymentStatusAudit_RetainerPaymentStatusId_ConcurrencyId] ON [dbo].[TRetainerPaymentStatusAudit] ([RetainerPaymentStatusId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
