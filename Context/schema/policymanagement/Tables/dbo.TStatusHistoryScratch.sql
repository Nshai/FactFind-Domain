CREATE TABLE [dbo].[TStatusHistoryScratch]
(
[StatusHistoryId] [int] NOT NULL IDENTITY(10311700, 1) NOT FOR REPLICATION,
[PolicyBusinessId] [int] NOT NULL,
[StatusId] [int] NOT NULL,
[StatusReasonId] [int] NULL,
[ChangedToDate] [datetime] NOT NULL,
[ChangedByUserId] [int] NOT NULL,
[DateOfChange] [datetime] NULL,
[LifeCycleStepFG] [bit] NOT NULL CONSTRAINT [DF_TStatusHistoryscratch_LifeCycleStepFG] DEFAULT ((0)),
[CurrentStatusFG] [bit] NOT NULL CONSTRAINT [DF_TStatusHistoryscratch_CurrentStatusFG] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TStatusHistoryscratch_ConcurrencyId] DEFAULT ((1)),
[migrationref] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TStatusHistoryScratch] ADD CONSTRAINT [PK_TStatusHistoryScratch] PRIMARY KEY NONCLUSTERED  ([StatusHistoryId]) WITH (FILLFACTOR=90)
GO
