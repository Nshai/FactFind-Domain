CREATE TABLE [dbo].[TRefRegistered]
(
[RefRegisteredID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefRegistered] ADD CONSTRAINT [PK_TRefRegistered] PRIMARY KEY CLUSTERED  ([RefRegisteredID])
GO
