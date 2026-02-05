CREATE TABLE [dbo].[TAccountToRelationshipTypeLink]
(
[AccountToRelationshipTypeLinkId] [int] NOT NULL IDENTITY(1, 1),
[RefRelationshipTypeId] [int] NOT NULL,
[AccountTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_AccountToRel__1] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAccountToRelationshipTypeLink] ADD CONSTRAINT [PK_TAccountToRelationshipTypeLink__1] PRIMARY KEY NONCLUSTERED  ([AccountToRelationshipTypeLinkId]) WITH (FILLFACTOR=80)
GO
