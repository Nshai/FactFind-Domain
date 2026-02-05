CREATE TABLE [dbo].[TAtrSystemCategoryAnswer]
(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AtrSystemCategoryId] int NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Value] [nvarchar](255) NOT NULL,
	CONSTRAINT [PK_TAtrSystemCategoryAnswer] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
) 
GO

ALTER TABLE 
	[dbo].[TAtrSystemCategoryAnswer]  
WITH CHECK 
ADD  CONSTRAINT 
	[FK_TAtrSystemCategoryAnswer_TAtrSystemCategory] 
FOREIGN KEY
	([AtrSystemCategoryId])
REFERENCES 
	[dbo].[TAtrSystemCategory] ([Id])
GO
