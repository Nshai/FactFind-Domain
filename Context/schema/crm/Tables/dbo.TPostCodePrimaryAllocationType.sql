CREATE TABLE [dbo].[TPostCodePrimaryAllocationType]
(
[PrimaryAllocationTypeId] [int] NOT NULL IDENTITY(1, 1),
[PrimaryAllocationTypeName] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPostCodePrimaryAllocationType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPostCodePrimaryAllocationType] ADD CONSTRAINT [PK_TPostCodePrimaryAllocationType] PRIMARY KEY CLUSTERED  ([PrimaryAllocationTypeId])
GO
