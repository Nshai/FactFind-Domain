CREATE TABLE [dbo].[TActivityOutcome]
(
[ActivityOutcomeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ActivityOutcomeName] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ArchiveFG] [bit] NOT NULL CONSTRAINT [DF_TActivityOutcome_ArchiveFG] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityOutcome_ConcurrencyId] DEFAULT ((1)),
[GroupId] [int] NULL
)
GO
ALTER TABLE [dbo].[TActivityOutcome] ADD CONSTRAINT [PK_TActivityOutcome] PRIMARY KEY CLUSTERED  ([ActivityOutcomeId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TActivityOutcome_GroupId] ON [dbo].[TActivityOutcome] ([GroupId])
GO
CREATE NONCLUSTERED INDEX [IX_TActivityOutcome_IndigoClientId] ON [dbo].[TActivityOutcome] ([IndigoClientId])
GO
