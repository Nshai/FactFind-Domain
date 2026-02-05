CREATE TABLE [dbo].[TRefObjective]
(
[RefObjectiveId] [int] NOT NULL IDENTITY(1, 1),
[ObjectiveName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[TargetValueFg] [tinyint] NULL,
[RetireFg] [tinyint] NULL,
[IndigoClientId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefObject_ConcurrencyId_1__63] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefObjective] ADD CONSTRAINT [PK_TRefObjective_2__63] PRIMARY KEY NONCLUSTERED  ([RefObjectiveId]) WITH (FILLFACTOR=80)
GO
