CREATE TABLE [dbo].[TFeePaymentStatus]
(
[FeePaymentStatusId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[FeeId] [int] NOT NULL,
[PaymentStatus] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[PaymentStatusNotes] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[PaymentStatusDate] [datetime] NOT NULL,
[UpdatedUserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeePaymentStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFeePaymentStatus] ADD CONSTRAINT [PK_TFeePaymentStatus] PRIMARY KEY NONCLUSTERED  ([FeePaymentStatusId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TFeePaymentStatus_FeeId] ON [dbo].[TFeePaymentStatus] ([FeeId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TFeePaymentStatus] ADD CONSTRAINT [FK_TFeePaymentStatus_FeeId_FeeId] FOREIGN KEY ([FeeId]) REFERENCES [dbo].[TFee] ([FeeId])
GO
