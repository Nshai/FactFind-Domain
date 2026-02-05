CREATE TABLE [dbo].[TRefPaymentshieldBenefitPeriod]
(
[RefPaymentshieldBenefitPeriodId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPaymentshieldBenefitPeriod_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPaymentshieldBenefitPeriod] ADD CONSTRAINT [PK_TRefPaymentshieldBenefitPeriod] PRIMARY KEY CLUSTERED  ([RefPaymentshieldBenefitPeriodId])
GO
