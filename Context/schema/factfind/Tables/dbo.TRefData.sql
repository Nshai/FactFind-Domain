CREATE TABLE [dbo].[TRefData]
(
[RefDataId] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (255) NOT NULL,
[Type] [varchar] (50) NOT NULL,
[Property] [varchar] (50) NOT NULL,
[RegionCode] [varchar] (2) NULL,
[Attributes] [nvarchar] (MAX) NULL,
[TenantId] [int] NULL,
[Archived] [bit] NOT NULL CONSTRAINT [DF_TRefData_Archived] DEFAULT ((0))
)
GO
      
ALTER TABLE [dbo].[TRefData] ADD CONSTRAINT [PK_TRefData] PRIMARY KEY CLUSTERED  ([RefDataId])
      
GO
