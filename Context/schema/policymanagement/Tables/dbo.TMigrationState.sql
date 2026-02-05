CREATE TABLE [dbo].[TMigrationState]
(
[MigrationStateId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Type] [nvarchar] (200) NOT NULL,
[AppId] [nvarchar] (200) NOT NULL,
[IsSuccess] [bit] NOT NULL,
[TenantId] [int] NOT NULL,
[UserId] [int] NULL,
[GroupId] [int] NULL,
[LegacyApp] [nvarchar] (200) NULL,
[Error] [nvarchar] (max) NULL,
[TimeStamp] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TMigrationState] ADD CONSTRAINT [PK_TMigrationState] PRIMARY KEY CLUSTERED  ([MigrationStateId])
GO
ALTER TABLE [dbo].[TMigrationState] ADD  CONSTRAINT [DF_TMigrationState_TimeStamp]  DEFAULT (getdate()) FOR [TimeStamp]
GO
