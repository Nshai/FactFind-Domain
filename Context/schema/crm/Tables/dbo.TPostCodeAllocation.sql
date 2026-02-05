CREATE TABLE [dbo].[TPostCodeAllocation]
(
[PostCodeAllocationId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[AllocationTypeId] [int] NOT NULL,
[MaxDistance] [int] NULL,
[SecondaryAllocationTypeId] [int] NULL,
[CanAssignPostCodeMoreThanOne] [bit] NULL,
[CanAssignAdviserMoreThanOne] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPostCodeAllocation_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPostCodeAllocation] ADD CONSTRAINT [PK_TPostCodeAllocation] PRIMARY KEY CLUSTERED  ([PostCodeAllocationId]) WITH (FILLFACTOR=80)
GO

