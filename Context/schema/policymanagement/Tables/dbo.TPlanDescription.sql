CREATE TABLE [dbo].[TPlanDescription]
(
[PlanDescriptionId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[SchemeOwnerCRMContactId] [int] NULL,
[SchemeStatus] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SchemeNumber] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SchemeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SchemeStatusDate] [datetime] NULL,
[SchemeSellingAdvisorPractitionerId] [int] NULL,
[MaturityDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPlanDescription_ConcurrencyId] DEFAULT ((1)),
[PlanMigrationRef] varchar(255)
)
GO
ALTER TABLE [dbo].[TPlanDescription] ADD CONSTRAINT [PK_TPlanDescription] PRIMARY KEY NONCLUSTERED  ([PlanDescriptionId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IDX_TPlanDescription_RefPlanType2ProdSubTypeId] ON [dbo].[TPlanDescription] ([RefPlanType2ProdSubTypeId]) WITH (FILLFACTOR=90)
GO
CREATE CLUSTERED INDEX [IDX1_TPlanDescription_RefProdProviderId_PlanDescriptionId] ON [dbo].[TPlanDescription] ([RefProdProviderId], [PlanDescriptionId]) WITH (FILLFACTOR=90)
GO
ALTER TABLE [dbo].[TPlanDescription] ADD CONSTRAINT [FK_TPlanDescription_RefPlanType2ProdSubTypeId_RefPlanType2ProdSubTypeId] FOREIGN KEY ([RefPlanType2ProdSubTypeId]) REFERENCES [dbo].[TRefPlanType2ProdSubType] ([RefPlanType2ProdSubTypeId])
GO
ALTER TABLE [dbo].[TPlanDescription] ADD CONSTRAINT [FK_TPlanDescription_RefProdProviderId_RefProdProviderId] FOREIGN KEY ([RefProdProviderId]) REFERENCES [dbo].[TRefProdProvider] ([RefProdProviderId])
GO
CREATE NONCLUSTERED INDEX IX_TPlanDescription_RefProdProviderId_PlanDescriptionId ON [dbo].[TPlanDescription] ([PlanDescriptionId],[RefProdProviderId]) INCLUDE ([RefPlanType2ProdSubTypeId]) 
GO
CREATE NONCLUSTERED INDEX IX_TPlanDescription_PlanDescriptionId_RefProdProviderId_RefPlanType2ProdSubTypeId ON [dbo].[TPlanDescription] ([PlanDescriptionId],[RefProdProviderId],[RefPlanType2ProdSubTypeId]) 
GO


