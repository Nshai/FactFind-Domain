CREATE TABLE [dbo].[TRefHouseType]
(
[RefHouseTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefHouseType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefHouseType] ADD CONSTRAINT [PK_TRefHouseType] PRIMARY KEY CLUSTERED  ([RefHouseTypeId])
GO
