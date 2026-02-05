CREATE TABLE [dbo].[TResourceList]
(
[ResourceListId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (8000) COLLATE Latin1_General_CI_AS NOT NULL,
[CalenderFG] [bit] NOT NULL CONSTRAINT [DF_TResourceList_CalenderFG] DEFAULT ((0)),
[IndClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TResourceList_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TResourceList] ADD CONSTRAINT [PK_TResourceList_ResourceListId] PRIMARY KEY NONCLUSTERED  ([ResourceListId]) WITH (FILLFACTOR=80)
GO
