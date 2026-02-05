CREATE TABLE [dbo].[TRefOpportunityStage]
(
[RefOpportunityStageId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Probability] [tinyint] NULL,
[OpenFG] [bit] NULL,
[ClosedFG] [bit] NULL,
[WonFG] [bit] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefOpport_ConcurrencyId_1__77] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefOpportunityStage] ADD CONSTRAINT [PK_TRefOpportunityStage_2__77] PRIMARY KEY NONCLUSTERED  ([RefOpportunityStageId]) WITH (FILLFACTOR=80)
GO
