CREATE TABLE [dbo].[TAtrSystemCategory]
(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Value] [nvarchar](255) NOT NULL,
	CONSTRAINT [PK_TAtrSystemCategory] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
) 
GO

CREATE UNIQUE INDEX 
	IDX_AtrSystemCategory_TypeName
ON 
	[dbo].[TAtrSystemCategory] ([Type], [Name])
GO
