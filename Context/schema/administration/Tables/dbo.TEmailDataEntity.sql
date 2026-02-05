CREATE TABLE [dbo].[TEmailDataEntity]
(
[EmailDataEntityId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Path] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEmailDataEntity_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEmailDataEntity] ADD CONSTRAINT [PK_TEmailDataEntity] PRIMARY KEY CLUSTERED  ([EmailDataEntityId]) WITH (FILLFACTOR=80)
GO
