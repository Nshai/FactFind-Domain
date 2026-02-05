CREATE TABLE [dbo].[TRefProductLink]
(
[RefProductLinkId] [int] NOT NULL IDENTITY(1, 1),
[ApplicationLinkId] [int] NULL,
[RefProductTypeId] [int] NOT NULL,
[ProductGroupData] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ProductTypeData] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefProductLink_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefProductLink_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefProductLink] ADD CONSTRAINT [PK_TRefProductLink] PRIMARY KEY NONCLUSTERED  ([RefProductLinkId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TRefProductLink] ON [dbo].[TRefProductLink] ([RefProductLinkId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX IX_TRefProductLink_RefProductTypeId ON [dbo].[TRefProductLink] ([RefProductTypeId]) INCLUDE ([ApplicationLinkId]) 
go
CREATE NONCLUSTERED INDEX IX_TRefProductLink_ApplicationLinkId_RefProductTypeId ON [dbo].[TRefProductLink] ([ApplicationLinkId],[RefProductTypeId]) 
go