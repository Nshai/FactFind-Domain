CREATE TABLE [dbo].[TApplicationLink]
(
[ApplicationLinkId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[RefApplicationId] [int] NOT NULL,
[MaxLicenceCount] [int] NULL,
[CurrentLicenceCount] [int] NULL,
[AllowAccess] [bit] NOT NULL CONSTRAINT [DF_TApplicationLink_AllowAccess] DEFAULT ((0)),
[WealthLinkEnabled] [bit] NOT NULL CONSTRAINT [DF_TApplicationLink_WealthLinkEnabled] DEFAULT ((0)),
[ExtranetURL] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ReferenceCode] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TApplicationLink_ConcurrencyId] DEFAULT ((0)),
[IntegratedSystemConfigRole] [int] NULL,
[SystemArchived] [bit] NOT NULL CONSTRAINT [DF_TApplicationLink_SystemArchived] DEFAULT(0)
)
GO
ALTER TABLE [dbo].[TApplicationLink] ADD CONSTRAINT [PK_TApplicationLink] PRIMARY KEY CLUSTERED  ([ApplicationLinkId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TApplicationLink_RefApplicationId] ON [dbo].[TApplicationLink] ([RefApplicationId]) INCLUDE ([ApplicationLinkId])
GO
