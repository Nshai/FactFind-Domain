CREATE TABLE [dbo].[TRefEValueAtrTemplate]
(
[RefEValueAtrTemplateId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefEValueAtrTemplate_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefEValueAtrTemplate] ADD CONSTRAINT [PK_TRefEValueAtrTemplate] PRIMARY KEY CLUSTERED  ([RefEValueAtrTemplateId])
GO
