CREATE TABLE [dbo].[TIOEntityType]
(
[IOEntityTypeId] [int] NOT NULL IDENTITY(1, 1),
[EntityTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIOEntityType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TIOEntityType] ADD CONSTRAINT [PK_TIOEntityType] PRIMARY KEY NONCLUSTERED  ([IOEntityTypeId])
GO
