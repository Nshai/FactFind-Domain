CREATE TABLE [dbo].[TRefFactFindSearchType]
(
[RefFactFindSearchTypeId] [int] NOT NULL IDENTITY(1, 1),
[SearchTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AllPlanTypes] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefFactFindSearchType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefFactFindSearchType] ADD CONSTRAINT [PK_TRefFactFindSearchType_RefFactFindSearchTypeId] PRIMARY KEY NONCLUSTERED  ([RefFactFindSearchTypeId]) WITH (FILLFACTOR=80)
GO
