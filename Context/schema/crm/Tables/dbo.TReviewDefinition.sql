CREATE TABLE [dbo].[TReviewDefinition]
(
[ReviewDefinitionId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TReviewDefinition_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TReviewDefinition] ADD CONSTRAINT [PK_TReviewDefinition_ReviewDefinitionId] PRIMARY KEY CLUSTERED  ([ReviewDefinitionId]) WITH (FILLFACTOR=80)
GO
