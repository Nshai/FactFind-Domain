CREATE TABLE [dbo].[TIndemnityRisk]
(
[IndemnityRiskId] [int] NOT NULL IDENTITY(1, 1),
[PolicyExpectedCommissionId] [int] NOT NULL,
[IndemnityRisk] [decimal] (10, 2) NOT NULL CONSTRAINT [DF_TIndemnityRisk_IndemnityRisk] DEFAULT ((0.00)),
[InForceDate] [datetime] NULL,
[ChargingPeriod] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndemnityRisk_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TIndemnityRisk] ADD CONSTRAINT [PK_TIndemnityRisk] PRIMARY KEY NONCLUSTERED  ([IndemnityRiskId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TIndemnityRisk] ADD CONSTRAINT [FK_TIndemnityRisk_PolicyExpectedCommissionId_TPolicyExpectedCommission] FOREIGN KEY ([PolicyExpectedCommissionId]) REFERENCES [dbo].[TPolicyExpectedCommission] ([PolicyExpectedCommissionId])
GO
