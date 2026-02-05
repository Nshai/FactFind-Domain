CREATE TABLE [dbo].[TRefMenuNodeRestrictedURLType]
(
[RefMenuNodeRestrictedURLTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefMenuNodeRestrictedURLType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefMenuNodeRestrictedURLType] ADD CONSTRAINT [PK_TRefMenuNodeRestrictedURLType] PRIMARY KEY CLUSTERED  ([RefMenuNodeRestrictedURLTypeId])
GO
