CREATE TABLE [dbo].[TBankPaymentDetail]
(
[BankPaymentDetailId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndClientId] [int] NOT NULL,
[BankDetailId] [int] NOT NULL,
[CRMOwnerId] [int] NOT NULL,
[RefPaymentTypeId] [int] NOT NULL,
[PayByChequeFg] [tinyint] NOT NULL CONSTRAINT [DF_TBankPaymentDetail_PayByCheque] DEFAULT ((0)),
[BlockedFg] [tinyint] NOT NULL CONSTRAINT [DF_TBankPaymentDetail_Blocked] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TBankPaymentDetail_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TBankPaymentDetail] ADD CONSTRAINT [PK_TBankPaymentDetail] PRIMARY KEY NONCLUSTERED  ([BankPaymentDetailId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TBankPaymentDetail_BankDetailId] ON [dbo].[TBankPaymentDetail] ([BankDetailId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TBankPaymentDetail_RefPaymentTypeId] ON [dbo].[TBankPaymentDetail] ([RefPaymentTypeId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TBankPaymentDetail] ADD CONSTRAINT [FK_TBankPaymentDetail_BankDetailId_BankDetailId] FOREIGN KEY ([BankDetailId]) REFERENCES [dbo].[TBankDetail] ([BankDetailId])
GO
ALTER TABLE [dbo].[TBankPaymentDetail] ADD CONSTRAINT [FK_TBankPaymentDetail_RefPaymentTypeId_RefPaymentTypeId] FOREIGN KEY ([RefPaymentTypeId]) REFERENCES [dbo].[TRefPaymentType] ([RefPaymentTypeId])
GO
CREATE NONCLUSTERED INDEX IX_TBankPaymentDetail_CRMOwnerId ON [dbo].[TBankPaymentDetail] ([CRMOwnerId])
GO