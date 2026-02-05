CREATE TABLE [dbo].[TAtrTemplateCombined]
(
[Guid] [uniqueidentifier] NOT NULL,
[AtrTemplateId] [int] NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Descriptor] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[Active] [bit] NOT NULL,
[HasModels] [bit] NOT NULL,
[BaseAtrTemplate] [uniqueidentifier] NULL,
[AtrRefPortfolioTypeId] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TAtrTemplateCombined_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrTemplateCombined_ConcurrencyId] DEFAULT ((1)),
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_80C6D707_BA91_4052_A844_66858F43B085_1609824847] DEFAULT (newid()),
[HasFreeTextAnswers] [bit] NOT NULL CONSTRAINT [DF_TAtrTemplateCombined_HasFreeTextAnswers] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TAtrTemplateCombined] ADD CONSTRAINT [PK_TAtrTemplateCombined] PRIMARY KEY NONCLUSTERED  ([Guid]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX IX_TAtrTemplateCombined_AtrTemplateId ON [dbo].[TAtrTemplateCombined] ([AtrTemplateId])
go
