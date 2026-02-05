CREATE TABLE [dbo].[TAdviseCategory]
(
[AdviseCategoryId] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TAdviseCategory_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviseCategory_ConcurrencyId] DEFAULT ((1)),
[GroupId] [int] NULL,
[IsPropagated] [bit] NOT NULL CONSTRAINT [DF_TAdviseCategory_IsPropagated] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviseCategory] ADD CONSTRAINT [PK_AdviseCategory] PRIMARY KEY CLUSTERED  ([AdviseCategoryId])
GO
