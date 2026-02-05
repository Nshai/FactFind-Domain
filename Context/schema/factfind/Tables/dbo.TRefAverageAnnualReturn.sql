CREATE TABLE [dbo].[TRefAverageAnnualReturn]
(
[RefAverageAnnualReturnId] [int] NOT NULL IDENTITY(1, 1),
[RiskProfileId] [int] NOT NULL,
[Term] [int] NOT NULL,
[AverageAnnualReturn] [decimal] (18, 10) NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefAverageAnnualReturn_ConcurrencyId] DEFAULT ((1)),
[ATRTemplateGuid] [uniqueidentifier] NULL
)
GO
