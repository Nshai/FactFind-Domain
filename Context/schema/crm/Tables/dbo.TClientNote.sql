CREATE TABLE [dbo].[TClientNote]
(
[ClientNoteId] [int] NOT NULL IDENTITY(1, 1),
[ClientId] [int] NOT NULL,
[Text] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[CreatedOn] [datetime] NOT NULL,
[CreatedBy] [int] NOT NULL,
[IsKeyNote] [bit] NOT NULL CONSTRAINT [DF_TClientNote_IsKeyNote] DEFAULT ((0)),
[UpdatedOn] [datetime] NULL,
[UpdatedBy] [int] NULL,
[PublishToPFP] [bit] NOT NULL CONSTRAINT [DF_TClientNote_PublishToPFP] DEFAULT ((0)),
[IsSystem] [bit] NOT NULL CONSTRAINT [DF_TClientNote_IsMigrated] DEFAULT ((0)),
[MigrationRef] [varchar] (150) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientNote_ConcurrencyId] DEFAULT ((1)),
[JointClientId][int] NULL,
[IsCriticalNote] [bit] NULL,
[TenantId] [int] NOT NULL,
)
GO
ALTER TABLE [dbo].[TClientNote] ADD CONSTRAINT [PK_TClientNote] PRIMARY KEY CLUSTERED  ([ClientNoteId])
GO
CREATE NONCLUSTERED INDEX [IX_TClientNote_TenantId_ClientId] ON [dbo].[TClientNote] ([TenantId],[ClientId])
GO
CREATE NONCLUSTERED INDEX [IX_TClientNote_TenantId_JointClientId] ON [dbo].[TClientNote] ([TenantId],[JointClientId])
GO
ALTER TABLE [dbo].[TClientNote] ADD CONSTRAINT [FK_TClientNote_TCrmContact] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
