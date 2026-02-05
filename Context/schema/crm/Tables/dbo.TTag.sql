CREATE TABLE [dbo].[TTag]
(
	[TagId] INT NOT NULL IDENTITY, 
    [EntityType] VARCHAR(20) NOT NULL, 
    [EntityId] INT NOT NULL, 
    [Name] NVARCHAR(100) NOT NULL, 
    [TenantId] INT NOT NULL, 
    [CreatedTimeStamp] DATETIME NOT NULL
)

ALTER TABLE [dbo].[TTag] ADD CONSTRAINT [PK_TTag]
PRIMARY KEY CLUSTERED ([TagId])


CREATE NONCLUSTERED INDEX [IDX_TTag_TenantId_Name] ON [dbo].[TTag] ([TenantId], [Name]) INCLUDE ([EntityId])
CREATE NONCLUSTERED INDEX [IDX_TTag_TenantId_EntityId] ON [dbo].[TTag] ([TenantId], [EntityId]) INCLUDE ([Name])
CREATE NONCLUSTERED INDEX [IDX_TTag_EntityId_Name] ON [dbo].[TTag] ([TenantId], [EntityType]) INCLUDE ([EntityId],[Name] )
CREATE NONCLUSTERED INDEX [IX_TTag_Entitytype] on [dbo].[TTag] (Entitytype)