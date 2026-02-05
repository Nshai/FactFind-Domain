CREATE TABLE [dbo].[TRefUnEmpAndDisabilityBenefitPeriod]
(
[RefUnEmpAndDisabilityBenefitPeriodId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefUnEmpAndDisabilityBenefitPeriod_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefUnEmpAndDisabilityBenefitPeriod] ADD CONSTRAINT [PK_TRefUnEmpAndDisabilityBenefitPeriod] PRIMARY KEY CLUSTERED  ([RefUnEmpAndDisabilityBenefitPeriodId])
GO
