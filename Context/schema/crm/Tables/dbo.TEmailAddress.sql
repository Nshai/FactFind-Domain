CREATE TABLE [dbo].[TEmailAddress]
(
[EmailAddressId] [int] NOT NULL IDENTITY(1, 1),
[EmailId] [int] NOT NULL,
[Address] [varchar] (300) COLLATE Latin1_General_CI_AS NOT NULL,
[IsCCAddress] [bit] NOT NULL CONSTRAINT [DF_TEmailAddress_IsCCAddress] DEFAULT ((0)),
[EntityOrganiserActivityId] [int] NULL CONSTRAINT [DF_TEmailAddress_EntityOrganiserActivityId] DEFAULT (NULL),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEmailAddress_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEmailAddress] ADD CONSTRAINT [PK_TEmailAddress] PRIMARY KEY CLUSTERED  ([EmailAddressId])
GO
ALTER TABLE [dbo].[TEmailAddress] ADD CONSTRAINT [FK_TEmailAddress_TEmail] FOREIGN KEY ([EmailId]) REFERENCES [dbo].[TEmail] ([EmailId])
GO
ALTER TABLE [dbo].[TEmailAddress] ADD CONSTRAINT [FK_TEmailAddress_TEntityOrganiserActivity] FOREIGN KEY ([EntityOrganiserActivityId]) REFERENCES [dbo].[TEntityOrganiserActivity] ([EntityOrganiserActivityId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEmailAddress_EntityOrganiserActivityId] ON [dbo].[TEmailAddress] ([EntityOrganiserActivityId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEmailAddress_EmailId] ON [dbo].[TEmailAddress] ([EmailId])
GO