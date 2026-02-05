CREATE TABLE [dbo].[TPolicyBusinessUnmatchedOwners]
(
	 [PolicyBusinessUnmatchedOwnersId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION
	,[PolicyBusinessUnmatchedId] [int] NOT NULL
	,[FirstName] varchar(100) NULL
	,[LastName] varchar(100) NULL
	,[Name] varchar(100) NULL
	,[ExternalReference] varchar(60) NULL
	,[Role] varchar(40) NULL
	,[Status] varchar(20) NULL
)
GO
ALTER TABLE [dbo].[TPolicyBusinessUnmatchedOwners] ADD CONSTRAINT [PK_TPolicyBusinessUnmatchedOwners] PRIMARY KEY ([PolicyBusinessUnmatchedOwnersId]) 
GO
ALTER TABLE [dbo].[TPolicyBusinessUnmatchedOwners] ADD CONSTRAINT [FK_TPolicyBusinessUnmatchedOwners_PolicyBusinessUnmatchedId_PolicyBusinessUnmatchedId] FOREIGN KEY ([PolicyBusinessUnmatchedId]) REFERENCES [dbo].[TPolicyBusinessUnmatched] ([PolicyBusinessUnmatchedId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusinessUnmatchedOwners_PolicyBusinessUnmatchedId] ON [dbo].[TPolicyBusinessUnmatchedOwners] ([PolicyBusinessUnmatchedId])
GO