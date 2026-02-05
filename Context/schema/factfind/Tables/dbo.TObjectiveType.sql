CREATE TABLE [dbo].[TObjectiveType]
(
[ObjectiveTypeId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[Archived] [bit] NOT NULL CONSTRAINT [DF_TObjectiveType_Archived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TObjectiveType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TObjectiveType] ADD CONSTRAINT [PK_TObjectiveType] PRIMARY KEY NONCLUSTERED  ([ObjectiveTypeId])
GO
