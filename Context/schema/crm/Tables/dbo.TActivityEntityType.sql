CREATE TABLE [dbo].[TActivityEntityType]
(
[ActivityEntityTypeId] [int] NOT NULL IDENTITY(1, 1),
[ActivityEntityTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityEntityType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TActivityEntityType] ADD CONSTRAINT [PK_TActivityEntityType] PRIMARY KEY CLUSTERED  ([ActivityEntityTypeId])
GO
