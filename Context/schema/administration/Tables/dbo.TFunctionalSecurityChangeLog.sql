CREATE TABLE [dbo].[TFunctionalSecurityChangeLog]
(
[FunctionalSecurityChangeLogId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[StampUserId] [int] NOT NULL,
[StampDateTime] [datetime] NOT NULL,
[SystemId] [int] NOT NULL,
[RoleId] [int] NULL,
[UserId] [int] NULL,
[Propagate] [bit] NOT NULL,
[RightMask] [int] NOT NULL,
)
GO
ALTER TABLE [dbo].[TFunctionalSecurityChangeLog] ADD CONSTRAINT [PK_TFunctionalSecurityChangeLog] PRIMARY KEY NONCLUSTERED ([FunctionalSecurityChangeLogId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TFunctionalSecurityChangeLog_TenantId_RoleId] ON [dbo].[TFunctionalSecurityChangeLog] ([TenantId],[RoleId]) WITH (FILLFACTOR=80)
GO
