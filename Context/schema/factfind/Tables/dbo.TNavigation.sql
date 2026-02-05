CREATE TABLE [dbo].[TNavigation]
(
[NavigationId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[Descriptor] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ParentId] [int] NULL,
[Ordinal] [tinyint] NULL,
[Stylesheet] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FactFindTypeId] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TNavigation_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TNavigation] ADD CONSTRAINT [PK_TNavigation] PRIMARY KEY NONCLUSTERED  ([NavigationId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_unq_dbo_TNavigation_FactFindTypeId] ON [dbo].[TNavigation] ([FactFindTypeId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TNavigation] WITH NOCHECK ADD CONSTRAINT [FK_TNavigation_FactFindTypeId_FactFindTypeId] FOREIGN KEY ([FactFindTypeId]) REFERENCES [dbo].[TFactFindType] ([FactFindTypeId])
GO
ALTER TABLE [dbo].[TNavigation] WITH NOCHECK ADD CONSTRAINT [FK_TNavigation_ParentId_NavigationId] FOREIGN KEY ([ParentId]) REFERENCES [dbo].[TNavigation] ([NavigationId])
GO
