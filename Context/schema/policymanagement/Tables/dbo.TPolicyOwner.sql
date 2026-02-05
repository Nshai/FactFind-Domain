CREATE TABLE [dbo].[TPolicyOwner]
(
	 [PolicyOwnerId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION
	,[CRMContactId] [int] NOT NULL
	,[PolicyDetailId] [int] NOT NULL
	,[OwnerOrder] [smallint] NULL
	,PlanMigrationRef varchar(255) NULL
	,[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyOwner_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPolicyOwner] ADD CONSTRAINT [PK_TPolicyOwner] PRIMARY KEY NONCLUSTERED  ([PolicyOwnerId]) 
GO
CREATE CLUSTERED INDEX [IDX1_TPolicyOwner_CRMContactId] ON [dbo].[TPolicyOwner] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyOwner_PolicyDetailId_PolicyOwnerId] ON [dbo].[TPolicyOwner] ([PolicyDetailId], [PolicyOwnerId])
GO
ALTER TABLE [dbo].[TPolicyOwner] ADD CONSTRAINT [FK_TPolicyOwner_PolicyDetailId_PolicyDetailId] FOREIGN KEY ([PolicyDetailId]) REFERENCES [dbo].[TPolicyDetail] ([PolicyDetailId])
GO
