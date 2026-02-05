CREATE TABLE [dbo].[TSectorRisk]
(
[SectorRiskId] [int] NOT NULL IDENTITY(1, 1),
[CategoryId] [int] NOT NULL,
[FundTypeId] [int] NOT NULL,
[RiskProfileId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TSectorRisk_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TSectorRisk] ADD CONSTRAINT [PK_TSectorRisk] PRIMARY KEY NONCLUSTERED  ([SectorRiskId]) WITH (FILLFACTOR=80)
GO
