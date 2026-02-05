CREATE TABLE [dbo].[TRefIncreaseAtType]
(
[RefIncreaseAtTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefIncreaseAtType] ADD CONSTRAINT [PK_TRefIncreaseAtType] PRIMARY KEY CLUSTERED  ([RefIncreaseAtTypeId])
GO
