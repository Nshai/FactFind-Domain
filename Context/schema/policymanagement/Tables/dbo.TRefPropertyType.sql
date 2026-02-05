CREATE TABLE [dbo].[TRefPropertyType]
(
[RefPropertyTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPropertyType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPropertyType] ADD CONSTRAINT [PK_TRefPropertyType] PRIMARY KEY CLUSTERED  ([RefPropertyTypeId])
GO
