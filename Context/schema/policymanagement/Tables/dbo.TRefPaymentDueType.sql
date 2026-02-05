CREATE TABLE [dbo].[TRefPaymentDueType]
(
[RefPaymentDueTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PaymentDueType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefLicenseTypeId] [int] NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPaymen_ConcurrencyId_3__63] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPaymentDueType] ADD CONSTRAINT [PK_TRefPaymentDueType_4__63] PRIMARY KEY NONCLUSTERED  ([RefPaymentDueTypeId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TRefPaymentDueType_RefPaymentDueTypeId_PaymentDueType_RetireFg_ConcurrencyId] ON [dbo].[TRefPaymentDueType] ([RefPaymentDueTypeId], [PaymentDueType], [RetireFg], [ConcurrencyId])
GO
