CREATE TABLE [dbo].[TRefApplication]
(
[RefApplicationId] [int] NOT NULL IDENTITY(1, 1),
[ApplicationName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ApplicationShortName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[RefApplicationTypeId] [int] NOT NULL,
[ImageName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AuthenticationMode] [smallint] NULL CONSTRAINT [DF_TRefApplication_AuthenticationMode] DEFAULT ((0)),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefApplication_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefApplication_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefApplication] ADD CONSTRAINT [PK_TRefApplication] PRIMARY KEY NONCLUSTERED  ([RefApplicationId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TRefApplication] ON [dbo].[TRefApplication] ([RefApplicationId]) WITH (FILLFACTOR=80)
GO
