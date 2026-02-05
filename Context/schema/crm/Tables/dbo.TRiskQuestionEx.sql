CREATE TABLE [dbo].[TRiskQuestionEx]
(
[ExtensibleColumnId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Type] [int] NOT NULL,
[TypeDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Size] [int] NULL CONSTRAINT [DF_TRiskQuest_Size_4__58] DEFAULT ((0)),
[Required] [int] NOT NULL CONSTRAINT [DF_TRiskQuest_Required_3__58] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRiskQuest_ConcurrencyId_2__58] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRiskQuestionEx] ADD CONSTRAINT [PK_TRiskQuestionEx_5__58] PRIMARY KEY NONCLUSTERED  ([ExtensibleColumnId]) WITH (FILLFACTOR=80)
GO
