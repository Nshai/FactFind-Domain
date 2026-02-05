CREATE TABLE [dbo].[TRefAccountAccess]
(
[RefAccountAccessId] [int] NOT NULL IDENTITY(1, 1),
[AccessTypeName] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefAccountAccess_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefAccountAccess] ADD CONSTRAINT [PK_TRefAccountAccess] PRIMARY KEY CLUSTERED  ([RefAccountAccessId])
GO
