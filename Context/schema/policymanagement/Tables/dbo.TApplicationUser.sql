CREATE TABLE [dbo].[TApplicationUser]
(
[ApplicationUserId] [int] NOT NULL IDENTITY(1, 1),
[RefApplicationId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[DateAdded] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TApplicationUser] ADD CONSTRAINT [PK_TApplicationUser] PRIMARY KEY CLUSTERED  ([ApplicationUserId])
GO
