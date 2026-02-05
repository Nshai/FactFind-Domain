CREATE TABLE [dbo].[TRefApplicationErrorMessageMapping]
(
[RefApplicationErrorMessageMappingId] [int] NOT NULL IDENTITY(1, 1),
[RefApplicationId] [int] NOT NULL,
[Code] [nvarchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[ErrorMessage] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[CustomData] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefApplicationErrorMessageMapping_ConcurrencyId] DEFAULT ((1)),
)
GO
ALTER TABLE [dbo].[TRefApplicationErrorMessageMapping] ADD CONSTRAINT [PK_TRefApplicationErrorMessageMapping] PRIMARY KEY CLUSTERED  ([RefApplicationErrorMessageMappingId])WITH (FILLFACTOR=80)
GO

