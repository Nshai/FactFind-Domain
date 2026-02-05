CREATE TABLE [dbo].[TDiscountToRole]
(
[DiscountToRoleId] [int] NOT NULL IDENTITY(1, 1),
[DiscountId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDiscountToRole_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TDiscountToRole] ADD CONSTRAINT [PK_TDiscountToRole] PRIMARY KEY CLUSTERED  ([DiscountToRoleId])
GO
CREATE NONCLUSTERED INDEX [IX_TDiscountToRole_DiscountId] ON [dbo].[TDiscountToRole] ([DiscountId])
GO
CREATE NONCLUSTERED INDEX [IX_TDiscountToRole_TenantId] ON [dbo].[TDiscountToRole] ([TenantId])
GO
ALTER TABLE [dbo].[TDiscountToRole] ADD CONSTRAINT [FK_TDiscountToRole_TDiscount] FOREIGN KEY ([DiscountId]) REFERENCES [dbo].[TDiscount] ([DiscountId]) ON DELETE CASCADE
GO
