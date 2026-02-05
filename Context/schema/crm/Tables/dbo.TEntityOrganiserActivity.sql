CREATE TABLE [dbo].[TEntityOrganiserActivity]
(
[EntityOrganiserActivityId] [int] NOT NULL IDENTITY(1, 1),
[ActivityEntityTypeId] [int] NOT NULL,
[EntityId] [int] NOT NULL,
[OrganiserActivityId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEntityOrganiserActivity_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEntityOrganiserActivity] ADD CONSTRAINT [PK_TEntityOrganiserActivity] PRIMARY KEY CLUSTERED  ([EntityOrganiserActivityId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEntityOrganiserActivity_OrganiserActivityId] ON [dbo].[TEntityOrganiserActivity] ([OrganiserActivityId])
GO
ALTER TABLE [dbo].[TEntityOrganiserActivity] ADD CONSTRAINT [FK_TEntityOrganiserActivity_TActivityEntity] FOREIGN KEY ([ActivityEntityTypeId]) REFERENCES [dbo].[TActivityEntityType] ([ActivityEntityTypeId])
GO
ALTER TABLE [dbo].[TEntityOrganiserActivity] ADD CONSTRAINT [FK_TEntityOrganiserActivity_TOrganiserActivity] FOREIGN KEY ([OrganiserActivityId]) REFERENCES [dbo].[TOrganiserActivity] ([OrganiserActivityId])
GO
CREATE NONCLUSTERED INDEX IX_TEntityOrganiserActivity_EntityId ON [dbo].[TEntityOrganiserActivity] ([EntityId])
GO