CREATE TABLE [dbo].[TRefClientType]
(
	[RefClientTypeId] [int] NOT NULL IDENTITY(1, 1),
	[Name] [nvarchar] (250) NOT NULL,
	[ClientTypeGroup] [nvarchar] (250),
	[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefClientType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefClientType] ADD CONSTRAINT [PK_TRefClientType] PRIMARY KEY CLUSTERED  ([RefClientTypeId])
GO
