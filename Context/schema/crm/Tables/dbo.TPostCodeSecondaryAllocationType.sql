CREATE TABLE [dbo].[TPostCodeSecondaryAllocationType]
(
[SecondaryAllocationTypeId] [int] NOT NULL IDENTITY(1, 1),
[SecondaryAllocationTypeName] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPostCodeSecondaryAllocationType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPostCodeSecondaryAllocationType] ADD CONSTRAINT [PK_TPostCodeSecondaryAllocationType] PRIMARY KEY CLUSTERED  ([SecondaryAllocationTypeId])
GO
