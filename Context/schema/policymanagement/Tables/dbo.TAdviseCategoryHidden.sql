CREATE TABLE [dbo].[TAdviseCategoryHidden]
(
[AdviseCategoryHiddenId] [int] NOT NULL IDENTITY(1, 1),
[AdviseCategoryId] [int] NOT NULL,
[GroupId] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviseCategoryHidden_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviseCategoryHidden] ADD CONSTRAINT [PK_TAdviseCategoryHidden] PRIMARY KEY CLUSTERED  ([AdviseCategoryHiddenId])
GO
