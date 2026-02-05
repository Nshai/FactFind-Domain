CREATE TABLE [dbo].[TPolicyBusinessUnmatched]
(
	 [PolicyBusinessUnmatchedId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION
	,[PolicyBusinessId] [int] NOT NULL
	,[TenantId] [int] NOT NULL
	,[AddressLine1] varchar(100) NULL
	,[AddressLine2] varchar(100) NULL
	,[AddressLine3] varchar(100) NULL
	,[AddressLine4] varchar(100) NULL
	,[CityTown] varchar(100) NULL
	,[Postcode] varchar(20) NULL
	,[CountryId] [int] NULL
	,[CountyId] [int] NULL
	,[AdviserName] varchar(255) NULL
	,[CreatedAt] [datetime] NOT NULL
	,[ChangedAt] [datetime] NULL
	,[MatchedAt] [datetime] NULL
	,[MatchedByUserId] [int] NULL
)
GO
ALTER TABLE [dbo].[TPolicyBusinessUnmatched] ADD CONSTRAINT [PK_TPolicyBusinessUnmatched] PRIMARY KEY ([PolicyBusinessUnmatchedId]) 
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TPolicyBusinessUnmatched_PolicyBusinessId] ON [dbo].[TPolicyBusinessUnmatched] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TPolicyBusinessUnmatched] ADD CONSTRAINT [FK_TPolicyBusinessUnmatched_PolicyBusinessId_PolicyBusinessId] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusinessUnmatched_TenantId_MatchedAt] ON [dbo].[TPolicyBusinessUnmatched] ([TenantId], [MatchedAt])
GO