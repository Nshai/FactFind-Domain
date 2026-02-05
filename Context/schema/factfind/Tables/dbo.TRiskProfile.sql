CREATE TABLE [dbo].[TRiskProfile]
(
[RiskProfileId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (30) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[LowerBand] [int] NULL,
[UpperBand] [int] NULL,
[Ordinal] [tinyint] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRiskProfile_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRiskProfile] ADD CONSTRAINT [PK_TRiskProfile] PRIMARY KEY NONCLUSTERED  ([RiskProfileId]) WITH (FILLFACTOR=80)
GO
