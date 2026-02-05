CREATE TABLE [dbo].[TExecutor]
(
[ExecutorId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[EstatePlanningId] [int] NULL,
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TExecutor_ConcurrencyId_1__57] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TExecutor] ADD CONSTRAINT [PK_TExecutor_2__57] PRIMARY KEY NONCLUSTERED  ([ExecutorId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TExecutor_EstatePlanningId] ON [dbo].[TExecutor] ([EstatePlanningId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TExecutor] ADD CONSTRAINT [FK_TExecutor_EstatePlanningId_EstatePlanningId] FOREIGN KEY ([EstatePlanningId]) REFERENCES [dbo].[TEstatePlanning] ([EstatePlanningId])
GO
