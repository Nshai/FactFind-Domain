CREATE TABLE [dbo].[TRefAnnuityPaymentType]
(
[RefAnnuityPaymentTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefAnnuityPaymentTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [TRefAnnuityPaymentType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefAnnuityPaymentType] ADD CONSTRAINT [PK_TRefAnnuityPaymentType] PRIMARY KEY CLUSTERED  ([RefAnnuityPaymentTypeId])
GO
