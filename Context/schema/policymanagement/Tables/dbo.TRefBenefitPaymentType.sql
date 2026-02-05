CREATE TABLE [dbo].[TRefBenefitPaymentType]
(
[RefBenefitPaymentTypeId] [int] NOT NULL IDENTITY(1, 1),
[BenefitTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrigoRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefBenefi_ConcurrencyId_1__63] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefBenefitPaymentType] ADD CONSTRAINT [PK_TRefBenefitPaymentType_2__63] PRIMARY KEY NONCLUSTERED  ([RefBenefitPaymentTypeId]) WITH (FILLFACTOR=80)
GO
