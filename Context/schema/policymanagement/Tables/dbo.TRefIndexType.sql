CREATE TABLE [dbo].[TRefIndexType]
(
[RefIndexTypeId] [int] NOT NULL IDENTITY(1, 1),
[IndexTypeName] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TRefIndexType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefIndexType] ADD CONSTRAINT [PK_TRefIndexType] PRIMARY KEY CLUSTERED  ([RefIndexTypeId])
GO
