CREATE TABLE [dbo].[TRefAverageVolatilityReturn]
(
[RefAverageVolatilityReturnId] [int] NOT NULL IDENTITY(1, 1),
[RiskProfileId] [int] NOT NULL,
[Term] [int] NOT NULL,
[AverageVolatilityReturn] [decimal] (18, 10) NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefAverageVolatilityReturn_ConcurrencyId] DEFAULT ((1)),
[ATRTemplateGuid] [uniqueidentifier] NULL
)
GO
