CREATE TABLE [dbo].[TMenuNodeRestrictedURL]
(
[MenuNodeRestrictedURLId] [int] NOT NULL IDENTITY(1, 1),
[RefMenuNodeRestrictedURLTypeId] [int] NOT NULL,
[MenuNodeRestrictedURLItemId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMenuNodeRestrictedURL_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMenuNodeRestrictedURL] ADD CONSTRAINT [PK_TMenuNodeRestrictedURL] PRIMARY KEY CLUSTERED  ([MenuNodeRestrictedURLId])
GO
ALTER TABLE [dbo].[TMenuNodeRestrictedURL] ADD CONSTRAINT [FK_TMenuNodeRestrictedURL_TMenuNodeRestrictedURLItem] FOREIGN KEY ([MenuNodeRestrictedURLItemId]) REFERENCES [dbo].[TMenuNodeRestrictedURLItem] ([MenuNodeRestrictedURLItemId])
GO
ALTER TABLE [dbo].[TMenuNodeRestrictedURL] ADD CONSTRAINT [FK_TMenuNodeRestrictedURL_TRefMenuNodeRestrictedURLType] FOREIGN KEY ([RefMenuNodeRestrictedURLTypeId]) REFERENCES [dbo].[TRefMenuNodeRestrictedURLType] ([RefMenuNodeRestrictedURLTypeId])
GO
