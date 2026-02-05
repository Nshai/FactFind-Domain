CREATE TABLE [dbo].[TPostCodeAllocationGroup]
(
[PostCodeAllocationGroupId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[AllocationGroupName] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPostCodeAllocationGroup_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPostCodeAllocationGroup] ADD CONSTRAINT [PK_TPostCodeAllocationGroup] PRIMARY KEY CLUSTERED  ([PostCodeAllocationGroupId])
GO
