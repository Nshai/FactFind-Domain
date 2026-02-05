CREATE TABLE [dbo].[TSection]
(
[SectionId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [int] NOT NULL,
[Url] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[DetailUrl] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[Editable] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSection_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSection] ADD CONSTRAINT [PK_TSection_SectionId] PRIMARY KEY CLUSTERED  ([SectionId]) WITH (FILLFACTOR=80)
GO
