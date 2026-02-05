CREATE TABLE [dbo].[TRoleResourceClaim]
(
[RoleResourceClaimId] [int] NOT NULL IDENTITY(1, 1),
[RoleId] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ResourceClaimId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TRoleResourceClaim] ADD CONSTRAINT [PK_TRoleResourceClaim] PRIMARY KEY CLUSTERED  ([RoleResourceClaimId])
GO
ALTER TABLE [dbo].[TRoleResourceClaim] ADD CONSTRAINT [FK_TRoleResourceClaim_TResourceClaim_ResourceClaimId] FOREIGN KEY ([ResourceClaimId]) REFERENCES [dbo].[TResourceClaim] ([ResourceClaimId]) ON DELETE CASCADE
GO
