CREATE TABLE [dbo].[TPostCodeAllocationGroupPostCodeAssigned]
(
[PostCodeAllocationGroupPostCodeAssignedId] [int] NOT NULL IDENTITY(1, 1),
[PostCodeAllocationGroupId] [int] NOT NULL,
[PostCodeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPostCodeAllocationGroupPostCodeAssigned_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPostCodeAllocationGroupPostCodeAssigned] ADD CONSTRAINT [PK_TPostCodeAllocationGroupPostCodeAssigned] PRIMARY KEY CLUSTERED  ([PostCodeAllocationGroupPostCodeAssignedId])
GO
ALTER TABLE [dbo].[TPostCodeAllocationGroupPostCodeAssigned] ADD CONSTRAINT [FK_TPostCodeAllocationGroupPostCodeAssigned_TPostCodeAllocationGroup] FOREIGN KEY ([PostCodeAllocationGroupId]) REFERENCES [dbo].[TPostCodeAllocationGroup] ([PostCodeAllocationGroupId])
GO

