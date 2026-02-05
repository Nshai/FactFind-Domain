CREATE TABLE [dbo].[TPac]
(
[PacId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Xml] [text] COLLATE Latin1_General_CI_AS NULL,
[Xsl] [text] COLLATE Latin1_General_CI_AS NULL,
[Extensible] [char] (10) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPac_ConcurrencyId_1__103] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPac] ADD CONSTRAINT [PK_TPac_2__103] PRIMARY KEY NONCLUSTERED  ([PacId]) WITH (FILLFACTOR=80)
GO
