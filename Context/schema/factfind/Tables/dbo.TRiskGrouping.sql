CREATE TABLE [dbo].[TRiskGrouping]
(
[RiskGroupingSyncId] [varchar] (50) CONSTRAINT [DF_TRiskGrouping_RiskGroupingSyncId] DEFAULT(NULL),
[RiskGroupingId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRiskGrouping_ConcurrencyId] DEFAULT ((1)),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Tolerance] [int] NULL,
[IsArchived] [bit] NULL,
[IndigoClientId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TRiskGrouping] ADD CONSTRAINT [PK_TRiskGrouping] PRIMARY KEY NONCLUSTERED  ([RiskGroupingId])
GO
