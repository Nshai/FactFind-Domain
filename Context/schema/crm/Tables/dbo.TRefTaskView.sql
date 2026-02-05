CREATE TABLE [dbo].[TRefTaskView]
(
[RefTaskViewId] [int] NOT NULL IDENTITY(1, 1),
[ViewName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[ArchiveFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefTaskVi_ConcurrencyId_1__54] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefTaskView] ADD CONSTRAINT [PK_TRefTaskView_2__54] PRIMARY KEY NONCLUSTERED  ([RefTaskViewId]) WITH (FILLFACTOR=80)
GO
