CREATE TABLE [dbo].[TStatusReasonRole]
(
[StatusReasonRoleId] [int] NOT NULL IDENTITY(1, 1),
[RoleId] [int] NOT NULL,
[StatusReasonId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TStatusReasonRole_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TStatusReasonRole] ADD CONSTRAINT [PK_TStatusReasonRole] PRIMARY KEY NONCLUSTERED  ([StatusReasonRoleId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TStatusReasonRole_StatusReasonId] ON [dbo].[TStatusReasonRole] ([StatusReasonId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TStatusReasonRole] ADD CONSTRAINT [FK_TStatusReasonRole_TStatusReason] FOREIGN KEY ([StatusReasonId]) REFERENCES [dbo].[TStatusReason] ([StatusReasonId])
GO
