CREATE TABLE [dbo].[TAllocatedTheme]
(
[AllocatedThemeId] [uniqueidentifier] NOT NULL CONSTRAINT [PK_TAllocatedTheme] DEFAULT (newsequentialid()),
[ThemeId] [uniqueidentifier] NOT NULL,
[TenantId] [int] NOT NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF__TAllocate__IsAct__0377C38A] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TAllocatedTheme] ADD CONSTRAINT [PK__TAllocatedTheme__018F7B18] PRIMARY KEY CLUSTERED  ([AllocatedThemeId])
GO
ALTER TABLE [dbo].[TAllocatedTheme] ADD CONSTRAINT [FK_TAllocatedTheme_TIndigoClient] FOREIGN KEY ([TenantId]) REFERENCES [dbo].[TIndigoClient] ([IndigoClientId])
GO
ALTER TABLE [dbo].[TAllocatedTheme] ADD CONSTRAINT [FK_TAllocatedTheme_TTheme] FOREIGN KEY ([ThemeId]) REFERENCES [dbo].[TTheme] ([ThemeId])
GO
