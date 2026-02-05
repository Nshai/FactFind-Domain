CREATE TABLE [dbo].[TOpportunityType]
(
[OpportunityTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[OpportunityTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ArchiveFG] [bit] NOT NULL CONSTRAINT [DF_TOpportunityType_ArchiveFG] DEFAULT ((0)),
[SystemFG] [bit] NOT NULL CONSTRAINT [DF_TOpportunityType_SystemFG] DEFAULT ((0)),
[InvestmentDefault] [bit] NOT NULL CONSTRAINT [DF_TOpportunityType_InvestmentDefault] DEFAULT ((0)),
[RetirementDefault] [bit] NOT NULL CONSTRAINT [DF_TOpportunityType_RetirementDefault] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOpportunityType_ConcurrencyId] DEFAULT ((1)),
[ObjectiveType] [varchar](20) NULL 
)
GO
ALTER TABLE [dbo].[TOpportunityType] ADD CONSTRAINT [PK_TOpportunityType] PRIMARY KEY CLUSTERED  ([OpportunityTypeId]) WITH (FILLFACTOR=75)
GO
CREATE NONCLUSTERED INDEX [IX_TOpportunityType] ON [dbo].[TOpportunityType] ([OpportunityTypeId], [IndigoClientId], [OpportunityTypeName])
GO
