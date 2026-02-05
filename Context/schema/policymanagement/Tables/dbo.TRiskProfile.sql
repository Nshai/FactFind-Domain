CREATE TABLE [dbo].[TRiskProfile]
(
[RiskProfileSyncId] [varchar] (111) CONSTRAINT [DF_TRiskProfile_RiskProfileSyncId] DEFAULT (NULL),
[RiskProfileId] [int] NOT NULL IDENTITY(1, 1),
[Descriptor] [varchar] (5000) COLLATE Latin1_General_CI_AS NOT NULL,
[BriefDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[RiskNumber] [int] NOT NULL,
[LowerBand] [int] NULL,
[UpperBand] [int] NULL,
[AtrTemplateGuid] [uniqueidentifier] NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TRiskProfile_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TRiskProfile] ADD CONSTRAINT [PK_TRiskProfile] PRIMARY KEY CLUSTERED  ([RiskProfileId]) WITH (FILLFACTOR=80)
GO
