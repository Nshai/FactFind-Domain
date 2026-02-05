CREATE TABLE [dbo].[TAtrCategory]
(
[AtrCategoryId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Guid] [uniqueidentifier] NOT NULL,
[TenantId] [int] NOT NULL,
[TenantGuid] [uniqueidentifier] NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TAtrCategory_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrCategory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrCategory] ADD CONSTRAINT [PK_TAtrCategory] PRIMARY KEY NONCLUSTERED  ([AtrCategoryId])
GO
