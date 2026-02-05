CREATE TABLE [dbo].[TSection]
(
[SectionId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[Descriptor] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[DataStore] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[DisplayType] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[LockType] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[Path] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[PdfAttributeSet] [varchar] (32) COLLATE Latin1_General_CI_AS NULL,
[Ordinal] [tinyint] NULL,
[NavigationId] [int] NULL,
[IndigoClientId] [int] NULL,
[PdfHide] [bit] NULL,
[PdfOrientation] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSection_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSection] ADD CONSTRAINT [PK_TSection] PRIMARY KEY NONCLUSTERED  ([SectionId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_unq_dbo_TSection_IndigoClientId] ON [dbo].[TSection] ([IndigoClientId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TSection] WITH NOCHECK ADD CONSTRAINT [FK_TSection_NavigationId_NavigationId] FOREIGN KEY ([NavigationId]) REFERENCES [dbo].[TNavigation] ([NavigationId])
GO
