CREATE TABLE [dbo].[TPostCodeAllocationGroupAdviserAssigned]
(
[PostCodeAllocationGroupAdviserAssignedId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[PostCodeAllocationGroupId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPostCodeAllocationGroupAdviserAssigned_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPostCodeAllocationGroupAdviserAssigned] ADD CONSTRAINT [PK_TPostCodeAllocationGroupAdviserAssigned] PRIMARY KEY CLUSTERED  ([PostCodeAllocationGroupAdviserAssignedId])
GO
ALTER TABLE [dbo].[TPostCodeAllocationGroupAdviserAssigned] ADD CONSTRAINT [FK_TPostCodeAllocationGroupAdviserAssigned_TCRMContact] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TPostCodeAllocationGroupAdviserAssigned] ADD CONSTRAINT [FK_TPostCodeAllocationGroupAdviserAssigned_TPostCodeAllocationGroup] FOREIGN KEY ([PostCodeAllocationGroupId]) REFERENCES [dbo].[TPostCodeAllocationGroup] ([PostCodeAllocationGroupId])
GO
