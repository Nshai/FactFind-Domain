CREATE TABLE [dbo].[TRefUserType]
(
[RefUserTypeId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[Url] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefUserType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefUserType] ADD CONSTRAINT [PK_TRefUserType] PRIMARY KEY CLUSTERED  ([RefUserTypeId]) WITH (FILLFACTOR=80)
GO
