CREATE TABLE [dbo].[TPFPGroupThemeConfiguration]
(
[GroupThemeConfigId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[TenantId] [int] NULL,
[GroupId] [int] NULL,
[Theme] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPFPGroupThemeConfiguration_ConcurencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPFPGroupThemeConfiguration] ADD CONSTRAINT [PK_TPFPGroupThemeConfiguration] PRIMARY KEY CLUSTERED  ([GroupThemeConfigId])
GO
CREATE NONCLUSTERED INDEX [IX_TPFPGroupThemeConfiguration_TenantId_GroupId] ON [dbo].[TPFPGroupThemeConfiguration] ([TenantId], [GroupId])
GO
ALTER TABLE [dbo].[TPFPGroupThemeConfiguration] ADD CONSTRAINT [FK_TPFPGroupThemeConfiguration_TGroup] FOREIGN KEY ([GroupId]) REFERENCES [dbo].[TGroup] ([GroupId])
GO
ALTER TABLE [dbo].[TPFPGroupThemeConfiguration] ADD CONSTRAINT [FK_TPFPGroupThemeConfiguration_TIndigoClient] FOREIGN KEY ([TenantId]) REFERENCES [dbo].[TIndigoClient] ([IndigoClientId])
GO
