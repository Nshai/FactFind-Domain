CREATE TABLE [dbo].[TMonthlyBenefit]
(
[MonthlyBenefitId] [int] NOT NULL IDENTITY(1, 1),
[Amount] [decimal] (19, 2) NOT NULL,
[DeferredPeriod] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMonthlyBenefit_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMonthlyBenefit] ADD CONSTRAINT [PK_TMonthlyBenefit] PRIMARY KEY CLUSTERED  ([MonthlyBenefitId])
GO
