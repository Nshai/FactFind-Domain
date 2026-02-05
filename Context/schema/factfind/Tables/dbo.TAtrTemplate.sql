CREATE TABLE [dbo].[TAtrTemplate]
(
[AtrTemplateSyncId] [int] CONSTRAINT [DF_TAtrTemplate_AtrTemplateSyncId] DEFAULT (NULL),
[AtrTemplateId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Descriptor] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_TAtrTemplate_Active] DEFAULT ((0)),
[HasModels] [bit] NOT NULL CONSTRAINT [DF_TAtrTemplate_HasModels] DEFAULT ((0)),
[BaseAtrTemplate] [uniqueidentifier] NULL,
[AtrRefPortfolioTypeId] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TAtrTemplate_Guid] DEFAULT (newid()),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TAtrTemplate_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrTemplate_ConcurrencyId] DEFAULT ((1)),
[HasFreeTextAnswers] [bit] NOT NULL CONSTRAINT [DF_TAtrTemplate_HasFreeTextAnswers] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TAtrTemplate] ADD CONSTRAINT [PK_TAtrTemplate] PRIMARY KEY NONCLUSTERED  ([AtrTemplateId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrTemplate_Active_IndigoClientId] ON [dbo].[TAtrTemplate] ([Active], [IndigoClientId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrTemplate_Guid] ON [dbo].[TAtrTemplate] ([Guid]) WITH (FILLFACTOR=80)
GO
