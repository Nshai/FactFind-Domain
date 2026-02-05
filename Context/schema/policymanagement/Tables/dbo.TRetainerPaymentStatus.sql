CREATE TABLE [dbo].[TRetainerPaymentStatus]
(
[RetainerPaymentStatusId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RetainerId] [int] NOT NULL,
[PaymentStatus] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[PaymentStatusNotes] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[PaymentStatusDate] [datetime] NOT NULL,
[UpdatedUserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRetainerPaymentStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRetainerPaymentStatus] ADD CONSTRAINT [PK_TRetainerPaymentStatus] PRIMARY KEY NONCLUSTERED  ([RetainerPaymentStatusId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRetainerPaymentStatus_RetainerId] ON [dbo].[TRetainerPaymentStatus] ([RetainerId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TRetainerPaymentStatus] ADD CONSTRAINT [FK_TRetainerPaymentStatus_RetainerId_RetainerId] FOREIGN KEY ([RetainerId]) REFERENCES [dbo].[TRetainer] ([RetainerId])
GO
