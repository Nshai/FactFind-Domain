CREATE TABLE [dbo].[TRole]
(
[RoleId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ParentRoleId] [int] NULL,
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefRole_ConcurrencyId_1__55] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRole] ADD CONSTRAINT [PK_TRefRole] PRIMARY KEY NONCLUSTERED  ([RoleId]) WITH (FILLFACTOR=80)
GO
