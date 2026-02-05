CREATE TABLE [dbo].[TRefArrangementType]
(
[RefArrangementTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[TRefArrangementType] ADD CONSTRAINT [PK_TRefArrangementType] PRIMARY KEY CLUSTERED  ([RefArrangementTypeId])
GO