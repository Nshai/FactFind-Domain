CREATE TABLE [dbo].[TTextMarketer]
(
[TextMarketerId] [int] NOT NULL IDENTITY(1, 1),
[UserName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Password] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[MessageFrom] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL,
[ApplicationLinkId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTTextMarketer_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TTextMarketer] ADD CONSTRAINT [PK_TTextMarketer] PRIMARY KEY CLUSTERED  ([TextMarketerId])
GO
ALTER TABLE [dbo].[TTextMarketer] ADD CONSTRAINT [FK_TTextMarketer_TApplicationLink] FOREIGN KEY ([ApplicationLinkId]) REFERENCES [dbo].[TApplicationLink] ([ApplicationLinkId])
GO
