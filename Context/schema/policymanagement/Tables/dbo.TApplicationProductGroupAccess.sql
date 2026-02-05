CREATE TABLE [dbo].[TApplicationProductGroupAccess]
(
[ApplicationProductGroupAccessId] [int] NOT NULL IDENTITY(1, 1),
[ApplicationLinkId] [int] NOT NULL,
[RefProductGroupId] [int] NOT NULL,
[AllowAccess] [bit] NOT NULL CONSTRAINT [DF_TApplicationProductGroupAccess_AllowAccess] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TApplicationProductGroupAccess_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TApplicationProductGroupAccess] ADD CONSTRAINT [PK_TApplicationProductGroupAccess] PRIMARY KEY NONCLUSTERED  ([ApplicationProductGroupAccessId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TApplicationProductGroupAccess] ON [dbo].[TApplicationProductGroupAccess] ([ApplicationProductGroupAccessId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX IX_TApplicationProductGroupAccess_RefProductGroupId ON [dbo].[TApplicationProductGroupAccess] ([RefProductGroupId]) INCLUDE ([ApplicationLinkId])
GO
CREATE NONCLUSTERED INDEX IX_TApplicationProductGroupAccess_ApplicationLinkId_RefProductGroupId ON [dbo].[TApplicationProductGroupAccess] ([ApplicationLinkId],[RefProductGroupId])
GO
