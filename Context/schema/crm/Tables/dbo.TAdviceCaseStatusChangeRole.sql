CREATE TABLE [dbo].[TAdviceCaseStatusChangeRole]
(
[AdviceCaseStatusChangeRoleId] [int] NOT NULL IDENTITY(1, 1),
[AdviceCaseStatusChangeId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseStatusChangeRole_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviceCaseStatusChangeRole] ADD CONSTRAINT [PK_TAdviceCaseStatusChangeRole] PRIMARY KEY NONCLUSTERED  ([AdviceCaseStatusChangeRoleId])
GO
