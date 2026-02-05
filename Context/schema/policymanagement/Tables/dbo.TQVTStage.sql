CREATE TABLE [dbo].[TQVTStage]
(
[QVTStageId] [int] NOT NULL IDENTITY(1, 1),
[Stage] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Extensible] [char] (10) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TQVTStage_ConcurrencyId_1__103] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQVTStage] ADD CONSTRAINT [PK_TQVTStage_2__103] PRIMARY KEY NONCLUSTERED  ([QVTStageId]) WITH (FILLFACTOR=80)
GO
