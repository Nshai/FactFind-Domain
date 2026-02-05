CREATE TABLE [dbo].[TProfileItem]
(
[ProfileItemId] [uniqueidentifier] NOT NULL,
[Key] [nvarchar] (1024) COLLATE Latin1_General_CI_AS NOT NULL,
[Value] [nvarchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[LastUpdated] [datetime] NOT NULL,
[UserId] [int] NOT NULL,
[TenantId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TProfileItem] ADD CONSTRAINT [PK_TProfileItem] PRIMARY KEY CLUSTERED  ([ProfileItemId])
GO
ALTER TABLE [dbo].[TProfileItem] ADD CONSTRAINT [FK_TProfileItem_TIndigoClient1] FOREIGN KEY ([TenantId]) REFERENCES [dbo].[TIndigoClient] ([IndigoClientId])
GO
ALTER TABLE [dbo].[TProfileItem] ADD CONSTRAINT [FK_TProfileItem_TUser1] FOREIGN KEY ([UserId]) REFERENCES [dbo].[TUser] ([UserId])
GO
CREATE UNIQUE INDEX IX_TProfileItem_TenantId_UserId_Key ON TProfileItem ([TenantId], [UserId], [Key]) INCLUDE ([Value])
GO
