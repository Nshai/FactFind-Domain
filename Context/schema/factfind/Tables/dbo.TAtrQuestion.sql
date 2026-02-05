CREATE TABLE [dbo].[TAtrQuestion]
(
[AtrQuestionSyncId] [varchar] (50) CONSTRAINT [DF_TAtrQuestion_AtrQuestionSyncId] DEFAULT (NULL),
[AtrQuestionId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (500) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [tinyint] NOT NULL,
[Investment] [bit] NOT NULL CONSTRAINT [DF_TAtrQuestion_Investment] DEFAULT ((0)),
[Retirement] [bit] NOT NULL CONSTRAINT [DF_TAtrQuestion_Retirement] DEFAULT ((0)),
[Active] [bit] NOT NULL CONSTRAINT [DF_TAtrQuestion_Active] DEFAULT ((0)),
[AtrTemplateGuid] [uniqueidentifier] NULL,
[IndigoClientId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TAtrQuestion_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrQuestion_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrQuestion] ADD CONSTRAINT [PK_TAtrQuestion] PRIMARY KEY NONCLUSTERED  ([AtrQuestionId]) WITH (FILLFACTOR=80)
GO
