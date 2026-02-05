CREATE TABLE [dbo].[TFeeStatusTransitionToRole]
(
[FeeStatusTransitionToRoleId] [int] NOT NULL IDENTITY(1, 1),
[FeeStatusTransitionId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeeStatusTransitionToRole_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFeeStatusTransitionToRole] ADD CONSTRAINT [PK_TFeeStatusTransitionToRole] PRIMARY KEY CLUSTERED  ([FeeStatusTransitionToRoleId])
GO
ALTER TABLE [dbo].[TFeeStatusTransitionToRole] ADD CONSTRAINT [FK_TFeeStatusTransitionToRole_TFeeStatusTransition] FOREIGN KEY ([FeeStatusTransitionId]) REFERENCES [dbo].[TFeeStatusTransition] ([FeeStatusTransitionId])
GO
