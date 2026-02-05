CREATE TABLE [dbo].[TCreateTenantLock]
(
[SourceTenantId] [bigint] NOT NULL,
[TenantName] [varchar] (64) NOT NULL,
[LockDate] [datetime2] NOT NULL
)
GO
ALTER TABLE [dbo].[TCreateTenantLock] ADD CONSTRAINT [PK_TCreateTenantLock_SourceTenantId_TenantName] PRIMARY KEY CLUSTERED ([SourceTenantId], [TenantName])
GO
ALTER TABLE [dbo].[TCreateTenantLock] ADD CONSTRAINT [DF_TCreateTenantLock_LockDate] DEFAULT (GetUTCDate()) FOR [LockDate]
GO
