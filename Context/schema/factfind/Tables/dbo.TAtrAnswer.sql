CREATE TABLE [dbo].[TAtrAnswer]
(
[AtrAnswerSyncId][varchar] (50) CONSTRAINT [DF_TAtrAnswer_AtrAnswerSyncId] DEFAULT (NULL),
[AtrAnswerId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [tinyint] NOT NULL,
[Weighting] [int] NOT NULL,
[AtrQuestionGuid] [uniqueidentifier] NULL,
[IndigoClientId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TAtrAnswer_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrAnswer_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrAnswer] ADD CONSTRAINT [PK_TAtrAnswer] PRIMARY KEY NONCLUSTERED  ([AtrAnswerId]) WITH (FILLFACTOR=80)
GO
