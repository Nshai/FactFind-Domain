CREATE TABLE [dbo].[TMenuNodeRestrictedByToTMenuNodeRestrictedURL]
(
[MenuNodeRestrictedByToTMenuNodeRestrictedURLId] [int] NOT NULL IDENTITY(1, 1),
[MenuNodeRestrictedById] [int] NOT NULL,
[MenuNodeRestrictedURLId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMenuNodeRestrictedByToTMenuNodeRestrictedURL_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMenuNodeRestrictedByToTMenuNodeRestrictedURL] ADD CONSTRAINT [PK_TMenuNodeRestrictedByToTMenuNodeRestrictedURL] PRIMARY KEY CLUSTERED  ([MenuNodeRestrictedByToTMenuNodeRestrictedURLId])
GO
ALTER TABLE [dbo].[TMenuNodeRestrictedByToTMenuNodeRestrictedURL] ADD CONSTRAINT [FK_TMenuNodeRestrictedByToTMenuNodeRestrictedURL_TMenuNodeRestrictedBy] FOREIGN KEY ([MenuNodeRestrictedById]) REFERENCES [dbo].[TMenuNodeRestrictedBy] ([MenuNodeRestrictedById])
GO
ALTER TABLE [dbo].[TMenuNodeRestrictedByToTMenuNodeRestrictedURL] ADD CONSTRAINT [FK_TMenuNodeRestrictedByToTMenuNodeRestrictedURL_TMenuNodeRestrictedURL] FOREIGN KEY ([MenuNodeRestrictedURLId]) REFERENCES [dbo].[TMenuNodeRestrictedURL] ([MenuNodeRestrictedURLId])
GO
