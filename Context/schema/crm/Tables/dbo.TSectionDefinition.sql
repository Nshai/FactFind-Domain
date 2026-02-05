CREATE TABLE [dbo].[TSectionDefinition]
(
[SectionDefinitionId] [int] NOT NULL IDENTITY(1, 1),
[ReviewDefinitionId] [int] NOT NULL,
[SectionId] [int] NOT NULL,
[Description] [varchar] (32) COLLATE Latin1_General_CI_AS NULL,
[Ordinal] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSectionDefinition_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSectionDefinition] ADD CONSTRAINT [PK_TSectionDefinition_SectionDefinitionId] PRIMARY KEY CLUSTERED  ([SectionDefinitionId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TSectionDefinition] ADD CONSTRAINT [FK_TSectionDefinition_ReviewDefinitionId_ReviewDefinitionId] FOREIGN KEY ([ReviewDefinitionId]) REFERENCES [dbo].[TReviewDefinition] ([ReviewDefinitionId])
GO
ALTER TABLE [dbo].[TSectionDefinition] ADD CONSTRAINT [FK_TSectionDefinition_SectionId_SectionId] FOREIGN KEY ([SectionId]) REFERENCES [dbo].[TSection] ([SectionId])
GO
